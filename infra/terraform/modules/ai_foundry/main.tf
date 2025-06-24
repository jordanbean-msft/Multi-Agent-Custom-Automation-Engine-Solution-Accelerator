module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

data "azapi_resource" "resource_group" {
  type = "Microsoft.Resources/resourceGroups@2021-04-01"
  name = var.resource_group_name
}

resource "azapi_resource" "ai_foundry_account" {
  type                      = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  name                      = "afa-${module.naming.cognitive_account.name}"
  location                  = var.location
  parent_id                 = data.azapi_resource.resource_group.id
  schema_validation_enabled = false
  body = {
    kind = "AIServices"
    sku = {
      name = var.sku_name
    }
    identity = {
      type = "UserAssigned"
      userAssignedIdentities = {
        "${var.user_assigned_identity_id}" = {}
      }
    }
    # identity = {
    #   type = "SystemAssigned"
    # }
    properties = {
      disableLocalAuth       = false
      allowProjectManagement = true
      customSubDomainName    = "afa-${module.naming.cognitive_account.name}"
      publicNetworkAccess    = var.public_network_access_enabled ? "Enabled" : "Disabled"
      networkAcls = {
        defaultAction = "Allow"
      }
      networkInjections = [
        {
          scenario                   = "agent"
          subnetArmId                = var.ai_foundry_agent_subnet_resource_id
          useMicrosoftManagedNetwork = false
        }
      ]
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "ai_foundry_account_diagnostic_setting" {
  name                       = "${azapi_resource.ai_foundry_account.name}-diagnostic-setting"
  target_resource_id         = azapi_resource.ai_foundry_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_resource_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_log {
    category_group = "Audit"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_cognitive_deployment" "aifoundry_deployment_gpt_4o" {
  depends_on = [
    azapi_resource.ai_foundry_account
  ]

  name                 = "${var.model_name}-${var.model_version}"
  cognitive_account_id = azapi_resource.ai_foundry_account.id

  sku {
    name     = var.model_sku_name
    capacity = var.model_sku_capacity
  }

  model {
    format  = var.model_format
    name    = var.model_name
    version = var.model_version
  }
}

# module "avm-res-network-privateendpoint" {
#   source                         = "Azure/avm-res-network-privateendpoint/azurerm"
#   version                        = "0.2.0"
#   name                           = "pe-afa-${module.naming.cognitive_account.name}"
#   network_interface_name         = "pe-afa-${module.naming.cognitive_account.name}-nic"
#   location                       = var.location
#   resource_group_name            = var.resource_group_name
#   private_connection_resource_id = resource.azapi_resource.ai_foundry_account.id
#   subnet_resource_id             = var.private_endpoint_subnet_resource_id
#   subresource_names              = ["account"]

# }

resource "azurerm_private_endpoint" "pe_aifoundry" {
  name                = "pe-afa-${module.naming.cognitive_account.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_resource_id
  private_service_connection {
    name                           = "pe-afa-${module.naming.cognitive_account.name}"
    private_connection_resource_id = azapi_resource.ai_foundry_account.id
    subresource_names = [
      "account"
    ]
    is_manual_connection = false
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}

resource "azapi_resource" "ai_foundry_project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  name      = "multi-agent-custom-automation-engine-solution-accelerator"
  location  = var.location
  parent_id = resource.azapi_resource.ai_foundry_account.id
  depends_on = [
    resource.azurerm_private_endpoint.pe_aifoundry
  ]
  body = {
    identity = {
      type = "UserAssigned"
      userAssignedIdentities = {
        "${var.user_assigned_identity_id}" = {}
      }
    }
    # identity = {
    #   type = "SystemAssigned"
    # }
    properties = {
      description = "multi-agent-custom-automation-engine-solution-accelerator"
      displayName = "multi-agent-custom-automation-engine-solution-accelerator"
    }
  }
}

resource "azapi_resource" "ai_foundry_project_connection_cosmos_db_account" {
  type      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name      = "cosmosdb"
  parent_id = resource.azapi_resource.ai_foundry_project.id
  body = {
    properties = {
      category = "CosmosDb"
      target   = var.cosmos_db_account_document_endpoint
      authType = "AAD"
      # authType = "ManagedIdentity"
      # credentials = {
      #   clientId   = var.user_assigned_identity_client_id
      #   resourceId = var.user_assigned_identity_id
      # }
      metadata = {
        ApiType    = "Azure"
        ResourceId = var.cosmos_db_account_resource_id
        location   = var.location
      }
    }
  }
}

resource "azapi_resource" "ai_foundry_project_connection_storage_account" {
  type      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name      = "storage"
  parent_id = resource.azapi_resource.ai_foundry_project.id
  body = {
    properties = {
      category = "AzureStorageAccount"
      target   = var.storage_account_primary_blob_endpoint
      authType = "AAD"
      # authType = "ManagedIdentity"
      # credentials = {
      #   clientId   = var.user_assigned_identity_client_id
      #   resourceId = var.user_assigned_identity_id
      # }
      metadata = {
        ApiType    = "Azure"
        ResourceId = var.storage_account_resource_id
        location   = var.location
      }
    }
  }
}

resource "azapi_resource" "ai_foundry_project_connection_ai_search" {
  type      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name      = "search"
  parent_id = resource.azapi_resource.ai_foundry_project.id
  body = {
    properties = {
      category = "CognitiveSearch"
      target   = "https://${var.ai_search_name}.search.windows.net"
      authType = "AAD"
      # authType = "ManagedIdentity"
      # credentials = {
      #   clientId   = var.user_assigned_identity_client_id
      #   resourceId = var.user_assigned_identity_id
      # }
      metadata = {
        ApiType    = "Azure"
        ApiVersion = "2024-05-01-preview"
        ResourceId = var.ai_search_resource_id
        location   = var.location
      }
    }
  }
}

# resource "azurerm_role_assignment" "cosmosdb_operator_ai_foundry_project" {
#   name                 = uuidv5("dns", "${azapi_resource.ai_foundry_project.name}${azapi_resource.ai_foundry_project.output.identity.principalId}cosmosdboperator")
#   scope                = var.cosmos_db_account_resource_id
#   role_definition_name = "Cosmos DB Operator"
#   principal_id         = azapi_resource.ai_foundry_project.output.identity.principalId
# }

# resource "azurerm_role_assignment" "storage_blob_data_contributor_ai_foundry_project" {
#   name                 = uuidv5("dns", "${azapi_resource.ai_foundry_project.name}${azapi_resource.ai_foundry_project.output.identity.principalId}storageblobdatacontributor")
#   scope                = var.storage_account_resource_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azapi_resource.ai_foundry_project.output.identity.principalId
# }

# resource "azurerm_role_assignment" "search_index_data_contributor_ai_foundry_project" {
#   name                 = uuidv5("dns", "${azapi_resource.ai_foundry_project.name}${azapi_resource.ai_foundry_project.output.identity.principalId}searchindexdatacontributor")
#   scope                = var.ai_search_resource_id
#   role_definition_name = "Search Index Data Contributor"
#   principal_id         = azapi_resource.ai_foundry_project.output.identity.principalId
# }

# resource "azurerm_role_assignment" "search_service_contributor_ai_foundry_project" {
#   name                 = uuidv5("dns", "${azapi_resource.ai_foundry_project.name}${azapi_resource.ai_foundry_project.output.identity.principalId}searchservicecontributor")
#   scope                = var.ai_search_resource_id
#   role_definition_name = "Search Service Contributor"
#   principal_id         = azapi_resource.ai_foundry_project.output.identity.principalId
# }

resource "azapi_resource" "ai_foundry_project_capability_hosts" {
  type      = "Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview"
  name      = "project-capability-host"
  parent_id = resource.azapi_resource.ai_foundry_project.id
  # depends_on = [
  #   resource.azurerm_role_assignment.cosmosdb_operator_ai_foundry_project,
  #   resource.azurerm_role_assignment.storage_blob_data_contributor_ai_foundry_project,
  #   resource.azurerm_role_assignment.search_index_data_contributor_ai_foundry_project,
  #   resource.azurerm_role_assignment.search_service_contributor_ai_foundry_project
  # ]
  body = {
    properties = {
      capabilityHostKind       = "Agents"
      vectorStoreConnections   = [resource.azapi_resource.ai_foundry_project_connection_ai_search.name]
      storageConnections       = [resource.azapi_resource.ai_foundry_project_connection_storage_account.name]
      threadStorageConnections = [resource.azapi_resource.ai_foundry_project_connection_cosmos_db_account.name]
    }
  }
}
