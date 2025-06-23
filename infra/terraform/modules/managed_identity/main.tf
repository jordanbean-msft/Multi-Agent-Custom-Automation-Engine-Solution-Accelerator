module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  suffix  = [var.name_suffix]
}

module "avm-res-managedidentity-userassignedidentity" {
  source              = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version             = "0.3.4"
  name                = module.naming.user_assigned_identity.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
