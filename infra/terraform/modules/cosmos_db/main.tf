module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-documentdb-databaseaccount" {
  source              = "Azure/avm-res-documentdb-databaseaccount/azurerm"
  version             = "0.8.0"
  name                = module.naming.cosmosdb_account.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  diagnostic_settings = {
    default = {
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  private_endpoints = {
    primary = {
      subnet_resource_id = var.private_endpoint_subnet_resource_id
      subresource_name   = "SQL"
    }
  }
  private_endpoints_manage_dns_zone_group = false
  public_network_access_enabled           = var.public_network_access_enabled
  role_assignments = {
    user_assigned_managed_identity = {
      principal_id   = var.user_assigned_identity_principal_id
      principal_type = "ServicePrincipal"
      #role_definition_id_or_name = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${module.naming.cosmosdb_account.name}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002" # Cosmos DB Built-in Data Contributor role
      role_definition_id_or_name = "Cosmos DB Operator"
    }
  }
  network_acl_bypass_for_azure_services = "true"
  geo_locations = [
    {
      location          = var.location
      failover_priority = 0
      zone_redundant    = var.zone_redundancy_enabled
    }
  ]
  local_authentication_disabled = true
  consistency_policy = {
    consistency_level = "Session"
  }
  free_tier_enabled                = false
  automatic_failover_enabled       = false
  multiple_write_locations_enabled = false
}
