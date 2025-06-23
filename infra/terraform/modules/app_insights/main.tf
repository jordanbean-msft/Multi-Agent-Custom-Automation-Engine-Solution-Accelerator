module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-insights-component" {
  source              = "Azure/avm-res-insights-component/azurerm"
  version             = "0.1.5"
  name                = module.naming.application_insights.name
  location            = var.location
  workspace_id        = var.workspace_resource_id
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
