module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-app-managedenvironment" {
  source                                     = "Azure/avm-res-app-managedenvironment/azurerm"
  version                                    = "0.2.1"
  name                                       = module.naming.container_app_environment.name
  location                                   = var.location
  resource_group_name                        = var.resource_group_name
  tags                                       = var.tags
  log_analytics_workspace_customer_id        = var.log_analytics_workspace_customer_id
  infrastructure_subnet_id                   = var.container_apps_subnet_resource_id
  log_analytics_workspace_destination        = "log-analytics"
  log_analytics_workspace_primary_shared_key = var.log_analytics_workspace_primary_shared_key
  diagnostic_settings = {
    default = {
      workspace_resource_id = var.log_analytics_workspace_resource_id
    }
  }
  workload_profile = [{
    name                  = var.workload_profile_type
    workload_profile_type = var.workload_profile_type
    minimum_count         = var.minimum_count
    maximum_count         = var.maximum_count
  }]
}
