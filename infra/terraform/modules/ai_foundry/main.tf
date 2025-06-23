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
      name = "S0"
    }
    identity = {
      type = "UserAssigned"
      userAssignedIdentities = {
        "${var.user_assigned_identity_id}" = {}
      }
    }
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

module "avm-res-network-privateendpoint" {
  source                         = "Azure/avm-res-network-privateendpoint/azurerm"
  version                        = "0.2.0"
  name                           = "pe-afa-${module.naming.cognitive_account.name}"
  network_interface_name         = "pe-afa-${module.naming.cognitive_account.name}-nic"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  private_connection_resource_id = resource.azapi_resource.ai_foundry_account.id
  subnet_resource_id             = var.private_endpoint_subnet_resource_id
  subresource_names              = ["account"]
}

resource "azapi_resource" "ai_foundry_project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  name      = "cloud-service-onboarding-agent"
  location  = var.location
  parent_id = resource.azapi_resource.ai_foundry_account.id
  depends_on = [
    module.avm-res-network-privateendpoint
  ]
  body = {
    identity = {
      type = "UserAssigned"
      userAssignedIdentities = {
        "${var.user_assigned_identity_id}" = {}
      }
    }
    properties = {
      description = "cloud-service-onboarding-agent"
      displayName = "cloud-service-onboarding-agent"
    }
  }
}

resource "azapi_resource" "ai_foundry_project_connection_cosmos_db_account" {
  type      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name      = "cosmosdb"
  parent_id = resource.azapi_resource.ai_foundry_project.id
  body = {
    properties = {
      category = "CosmosDB"
      target   = var.cosmos_db_account_document_endpoint
      authType = "AAD"
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
      metadata = {
        ApiType    = "Azure"
        ApiVersion = "2024-05-01-preview"
        ResourceId = var.ai_search_resource_id
        location   = var.location
      }
    }
  }
}

resource "azapi_resource" "ai_foundry_project_capability_hosts" {
  type      = "Microsoft.CognitiveServices/accounts/projects/capabilityHosts@2025-04-01-preview"
  name      = "project-capability-host"
  parent_id = resource.azapi_resource.ai_foundry_project.id
  body = {
    properties = {
      capabilityHostKind       = "Agents"
      vectorStoreConnections   = [resource.azapi_resource.ai_foundry_project_connection_ai_search.name]
      storageConnections       = [resource.azapi_resource.ai_foundry_project_connection_storage_account.name]
      threadStorageConnections = [resource.azapi_resource.ai_foundry_project_connection_cosmos_db_account.name]
    }
  }
}
