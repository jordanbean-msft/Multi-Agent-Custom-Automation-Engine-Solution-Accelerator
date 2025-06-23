locals {
  tags           = { azd-env-name : var.environment_name }
  sha            = base64encode(sha256("${var.location}${data.azurerm_client_config.current.subscription_id}${var.resource_group_name}"))
  resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
  backend_container_apps_environment_variables = [
    {
      name  = "COSMOSDB_ENDPOINT"
      value = module.cosmos_db.cosmos_db_account_document_endpoint
    },
    {
      name  = "COSMOSDB_DATABASE"
      value = "" //module.cosmos_db.cosmos_db_account_database_name
    },
    {
      name  = "COSMOSDB_CONTAINER"
      value = "" // module.cosmos_db.cosmos_db_account_container_name
    },
    {
      name  = "AZURE_OPENAI_ENDPOINT"
      value = "https://${module.ai_foundry.ai_foundry_account_name}.openai.azure.com/"
    },
    {
      name  = "AZURE_OPENAI_MODEL_NAME"
      value = "" //module.ai_foundry.ai_foundry_model_name
    },
    {
      name  = "AZURE_OPENAI_DEPLOYMENT_NAME"
      value = "" //aiFoundryAiServicesModelDeployment.name
    },
    {
      name  = "AZURE_OPENAI_API_VERSION"
      value = "2025-01-01-preview"
    },
    {
      name  = "APPLICATIONINSIGHTS_INSTRUMENTATION_KEY"
      value = module.application_insights.application_insights_instrumentation_key
    },
    {
      name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
      value = module.application_insights.application_insights_connection_string
    },
    {
      name  = "AZURE_AI_SUBSCRIPTION_ID"
      value = data.azurerm_client_config.current.subscription_id
    },
    {
      name  = "AZURE_AI_RESOURCE_GROUP"
      value = var.resource_group_name
    },
    {
      name  = "AZURE_AI_PROJECT_NAME"
      value = module.ai_foundry.ai_foundry_project_name
    },
    {
      name  = "FRONTEND_SITE_NAME"
      value = "" //module.web_site.resource_uri
    },
    {
      name  = "AZURE_AI_AGENT_ENDPOINT"
      value = "https://${module.ai_foundry.ai_foundry_account_name}.services.ai.azure.com/projects/${module.ai_foundry.ai_foundry_project_name}"
    },
    {
      name  = "AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME"
      value = "" //module.ai_foundry.ai_foundry_model_name
    }
  ]
  web_site_app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT      = "true"
    WEBSITES_PORT                       = "3000"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "1800" // 30 minutes, adjust as needed
    BACKEND_API_URL                     = module.container_apps_backend.container_apps_fqdn_url
    AUTH_ENABLED                        = "false"
    WEBSITE_PULL_IMAGE_OVER_VNET        = "true"
  }
}

data "azurerm_subnet" "private_endpoint_subnet" {
  name                 = var.network.private_endpoint_subnet_name
  virtual_network_name = var.network.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "container_apps_subnet" {
  name                 = var.network.container_apps_subnet_name
  virtual_network_name = var.network.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "ai_foundry_agent_subnet" {
  name                 = var.network.ai_foundry_agent_subnet_name
  virtual_network_name = var.network.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "app_service_subnet" {
  name                 = var.network.app_service_subnet_name
  virtual_network_name = var.network.virtual_network_name
  resource_group_name  = var.resource_group_name
}

# ------------------------------------------------------------------------------------------------------
# Deploy Log Analytics Workspace
# ------------------------------------------------------------------------------------------------------

module "log_analytics_workspace" {
  source              = "./modules/log_analytics"
  name_suffix         = local.resource_token
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy Application Insights
# ------------------------------------------------------------------------------------------------------

module "application_insights" {
  source                = "./modules/app_insights"
  name_suffix           = local.resource_token
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = module.log_analytics_workspace.log_analytics_workspace_resource_id
  tags                  = local.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy Managed Identity
# ------------------------------------------------------------------------------------------------------

module "managed_identity" {
  source              = "./modules/managed_identity"
  name_suffix         = local.resource_token
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy Container Registry
# ------------------------------------------------------------------------------------------------------

module "container_registry" {
  source                              = "./modules/container_registry"
  name_suffix                         = local.resource_token
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  log_analytics_workspace_resource_id = module.log_analytics_workspace.log_analytics_workspace_resource_id
  public_network_access_enabled       = var.public_network_access_enabled
  private_endpoint_subnet_resource_id = module.virtual_network.private_endpoint_subnet_resource_id
  user_assigned_identity_principal_id = module.managed_identity.user_assigned_identity_principal_id
  zone_redundancy_enabled             = var.zone_redundancy_enabled
}

# ------------------------------------------------------------------------------------------------------
# Deploy Storage Account
# ------------------------------------------------------------------------------------------------------

module "storage_account" {
  source                              = "./modules/storage_account"
  name_suffix                         = local.resource_token
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  log_analytics_workspace_resource_id = module.log_analytics_workspace.log_analytics_workspace_resource_id
  public_network_access_enabled       = var.public_network_access_enabled
  private_endpoint_subnet_resource_id = module.virtual_network.private_endpoint_subnet_resource_id
  user_assigned_identity_principal_id = module.managed_identity.user_assigned_identity_principal_id
  account_tier                        = var.storage_account.account_tier
  account_replication_type            = var.storage_account.account_replication_type
}

# ------------------------------------------------------------------------------------------------------
# Deploy Virtual Network
# ------------------------------------------------------------------------------------------------------

module "virtual_network" {
  source                              = "./modules/virtual_network"
  container_apps_subnet_resource_id   = data.azurerm_subnet.container_apps_subnet.id
  private_endpoint_subnet_resource_id = data.azurerm_subnet.private_endpoint_subnet.id
  ai_foundry_agent_subnet_resource_id = data.azurerm_subnet.ai_foundry_agent_subnet.id
  app_service_subnet_resource_id      = data.azurerm_subnet.app_service_subnet.id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Container Apps Environment
# ------------------------------------------------------------------------------------------------------

module "container_apps_environment" {
  source                                     = "./modules/container_apps_environment"
  name_suffix                                = local.resource_token
  location                                   = var.location
  resource_group_name                        = var.resource_group_name
  log_analytics_workspace_resource_id        = module.log_analytics_workspace.log_analytics_workspace_resource_id
  log_analytics_workspace_customer_id        = module.log_analytics_workspace.log_analytics_workspace_customer_id
  log_analytics_workspace_primary_shared_key = module.log_analytics_workspace.log_analytics_workspace_primary_shared_key
  public_network_access_enabled              = var.public_network_access_enabled
  container_apps_subnet_resource_id          = module.virtual_network.container_apps_subnet_resource_id
  user_assigned_identity_principal_id        = module.managed_identity.user_assigned_identity_principal_id
  workload_profile_type                      = var.container_apps.workload_profile_type
  minimum_count                              = var.container_apps.minimum_count
  maximum_count                              = var.container_apps.maximum_count
}

# ------------------------------------------------------------------------------------------------------
# Deploy Container Apps - Backend
# ------------------------------------------------------------------------------------------------------

module "container_apps_backend" {
  source                                 = "./modules/container_apps"
  name                                   = var.container_apps.backend.name
  location                               = var.location
  resource_group_name                    = var.resource_group_name
  public_network_access_enabled          = var.public_network_access_enabled
  user_assigned_identity_resource_id     = module.managed_identity.user_assigned_identity_id
  container_apps_environment_resource_id = module.container_apps_environment.container_apps_environment_id
  container_registry_hostname            = module.container_registry.container_registry_login_server
  ingress                                = var.container_apps.backend.ingress
  scale                                  = var.container_apps.backend.scale
  containers                             = var.container_apps.backend.containers
  environment_variables                  = local.backend_container_apps_environment_variables
}

# ------------------------------------------------------------------------------------------------------
# Deploy Cosmos DB
# ------------------------------------------------------------------------------------------------------

module "cosmos_db" {
  source                              = "./modules/cosmos_db"
  name_suffix                         = local.resource_token
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  log_analytics_workspace_resource_id = module.log_analytics_workspace.log_analytics_workspace_resource_id
  public_network_access_enabled       = var.public_network_access_enabled
  private_endpoint_subnet_resource_id = module.virtual_network.private_endpoint_subnet_resource_id
  user_assigned_identity_principal_id = module.managed_identity.user_assigned_identity_principal_id
  document_time_to_live               = var.cosmos_db.document_time_to_live
  max_throughput                      = var.cosmos_db.max_throughput
  zone_redundancy_enabled             = var.zone_redundancy_enabled
  subscription_id                     = data.azurerm_client_config.current.subscription_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy AI Search
# ------------------------------------------------------------------------------------------------------

module "ai_search" {
  source                              = "./modules/ai_search"
  name_suffix                         = local.resource_token
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  log_analytics_workspace_resource_id = module.log_analytics_workspace.log_analytics_workspace_resource_id
  public_network_access_enabled       = var.public_network_access_enabled
  private_endpoint_subnet_resource_id = module.virtual_network.private_endpoint_subnet_resource_id
  user_assigned_identity_principal_id = module.managed_identity.user_assigned_identity_principal_id
}

# -------------------------------------------------------------------------------------------------------
# Deploy AI Foundry
# -------------------------------------------------------------------------------------------------------

module "ai_foundry" {
  source                                = "./modules/ai_foundry"
  name_suffix                           = local.resource_token
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  log_analytics_workspace_resource_id   = module.log_analytics_workspace.log_analytics_workspace_resource_id
  public_network_access_enabled         = var.public_network_access_enabled
  private_endpoint_subnet_resource_id   = module.virtual_network.private_endpoint_subnet_resource_id
  user_assigned_identity_id             = module.managed_identity.user_assigned_identity_id
  storage_account_resource_id           = module.storage_account.storage_account_id
  storage_account_primary_blob_endpoint = module.storage_account.storage_account_primary_blob_endpoint
  cosmos_db_account_resource_id         = module.cosmos_db.cosmos_db_account_id
  ai_search_resource_id                 = module.ai_search.ai_search_id
  ai_search_name                        = module.ai_search.ai_search_name
  cosmos_db_account_document_endpoint   = module.cosmos_db.cosmos_db_account_document_endpoint
  ai_foundry_agent_subnet_resource_id   = module.virtual_network.ai_foundry_agent_subnet_resource_id
}

# -------------------------------------------------------------------------------------------------------
# Deploy App Service Plan
# -------------------------------------------------------------------------------------------------------

module "app_service_plan" {
  source              = "./modules/app_service_plan"
  name_suffix         = local.resource_token
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
  os_type             = "Linux"
  sku_name            = var.web_site.sku_name
}

# -------------------------------------------------------------------------------------------------------
# Deploy Web Site
# -------------------------------------------------------------------------------------------------------

module "web_site" {
  source                              = "./modules/web_site"
  name_suffix                         = local.resource_token
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  log_analytics_workspace_resource_id = module.log_analytics_workspace.log_analytics_workspace_resource_id
  os_type                             = "Linux"
  service_plan_resource_id            = module.app_service_plan.app_service_plan_resource_id
  kind                                = "webapp"
  app_settings                        = local.web_site_app_settings
  site_config = {
    linux_fx_version                              = "DOCKER|${var.web_site.image_name}"
    container_registry_managed_identity_client_id = module.managed_identity.user_assigned_identity_client_id
    container_registry_use_managed_identity       = true
    vnet_route_all_enabled                        = true
    # application_stack = {
    #   docker_image_name   = var.web_site.image_name
    #   docker_registry_url = module.container_registry.container_registry_login_server
    # }
  }
  public_network_access_enabled       = var.public_network_access_enabled
  private_endpoint_subnet_resource_id = module.virtual_network.private_endpoint_subnet_resource_id
  app_service_subnet_resource_id      = module.virtual_network.app_service_subnet_resource_id
  user_assigned_identity_resource_id  = module.managed_identity.user_assigned_identity_id
}
