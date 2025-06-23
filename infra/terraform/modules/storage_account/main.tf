module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-storage-storageaccount" {
  source              = "Azure/avm-res-storage-storageaccount/azurerm"
  version             = "0.6.3"
  name                = module.naming.storage_account.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  account_tier        = var.account_tier
  diagnostic_settings_blob = {
    default = {
      name                  = "blob"
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  diagnostic_settings_file = {
    default = {
      name                  = "file"
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  diagnostic_settings_queue = {
    default = {
      name                  = "queue"
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  diagnostic_settings_storage_account = {
    default = {
      name                  = "storageAccount"
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  diagnostic_settings_table = {
    default = {
      name                  = "table"
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  network_rules = {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
  public_network_access_enabled = var.public_network_access_enabled
  role_assignments = {
    user_assigned_managed_identity = {
      principal_id               = var.user_assigned_identity_principal_id
      principal_type             = "ServicePrincipal"
      role_definition_id_or_name = "Storage Blob Data Contributor"
    }
  }
  private_endpoints = {
    blob = {
      name               = "pe-blob-${module.naming.storage_account.name}"
      subnet_resource_id = var.private_endpoint_subnet_resource_id
      subresource_name   = "blob"
    }
    file = {
      name               = "pe-file-${module.naming.storage_account.name}"
      subnet_resource_id = var.private_endpoint_subnet_resource_id
      subresource_name   = "file"
    }
    queue = {
      name               = "pe-queue-${module.naming.storage_account.name}"
      subnet_resource_id = var.private_endpoint_subnet_resource_id
      subresource_name   = "queue"
    }
    table = {
      name               = "pe-table-${module.naming.storage_account.name}"
      subnet_resource_id = var.private_endpoint_subnet_resource_id
      subresource_name   = "table"
    }
  }
  private_endpoints_manage_dns_zone_group = false
  account_replication_type                = var.account_replication_type
}
