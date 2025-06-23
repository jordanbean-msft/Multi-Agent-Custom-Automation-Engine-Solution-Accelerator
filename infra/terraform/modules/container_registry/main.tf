module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-containerregistry-registry" {
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = "0.4.0"

  name                   = module.naming.container_registry.name
  location               = var.location
  resource_group_name    = var.resource_group_name
  tags                   = var.tags
  admin_enabled          = false
  anonymous_pull_enabled = false
  sku                    = "Premium"
  diagnostic_settings = {
    default = {
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  network_rule_bypass_option    = "AzureServices"
  public_network_access_enabled = var.public_network_access_enabled
  role_assignments = {
    user_assigned_managed_identity = {
      principal_id               = var.user_assigned_identity_principal_id
      principal_type             = "ServicePrincipal"
      role_definition_id_or_name = "AcrPull"
    }
  }
  private_endpoints = {
    primary = {
      subnet_resource_id = var.private_endpoint_subnet_resource_id
    }
  }
  private_endpoints_manage_dns_zone_group = false
  zone_redundancy_enabled                 = var.zone_redundancy_enabled
  retention_policy_in_days                = 0
}
