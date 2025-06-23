module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-web-serverfarm" {
  source              = "Azure/avm-res-web-serverfarm/azurerm"
  version             = "0.7.0"
  name                = module.naming.application_insights.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  os_type             = var.os_type
  sku_name            = var.sku_name
}
