module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-operationalinsights-workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"

  location                                           = var.location
  resource_group_name                                = var.resource_group_name
  name                                               = module.naming.log_analytics_workspace.name
  log_analytics_workspace_retention_in_days          = 30
  log_analytics_workspace_sku                        = "PerGB2018"
  tags                                               = var.tags
  log_analytics_workspace_internet_ingestion_enabled = true
  log_analytics_workspace_internet_query_enabled     = true
}
