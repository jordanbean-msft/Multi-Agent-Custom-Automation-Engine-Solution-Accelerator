module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-web-site" {
  source                      = "Azure/avm-res-web-site/azurerm"
  version                     = "0.17.2"
  name                        = module.naming.application_insights.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tags                        = var.tags
  enable_application_insights = true
  application_insights = {
    workspace_resource_id = var.log_analytics_workspace_resource_id
  }
  diagnostic_settings = {
    default = {
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  os_type                       = var.os_type
  service_plan_resource_id      = var.service_plan_resource_id
  kind                          = var.kind
  virtual_network_subnet_id     = var.app_service_subnet_resource_id
  vnet_image_pull_enabled       = true
  app_settings                  = var.app_settings
  site_config                   = var.site_config
  public_network_access_enabled = var.public_network_access_enabled
  private_endpoints = {
    default = {
      subnet_resource_id = var.private_endpoint_subnet_resource_id
    }
  }
  managed_identities = {
    user_assigned_resource_ids = [var.user_assigned_identity_resource_id]
  }
}
