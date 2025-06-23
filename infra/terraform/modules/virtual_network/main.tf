resource "azapi_update_resource" "add_subnet_delegation_for_container_apps_subnet" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2022-05-01"
  resource_id = var.container_apps_subnet_resource_id

  body = {
    properties = {
      delegations = [
        {
          name = "aca-delegation"
          properties = {
            serviceName = "Microsoft.App/environments"
          }
        }
      ]
    }
  }
}

resource "azapi_update_resource" "add_subnet_delegation_for_ai_foundry_agent_subnet" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2022-05-01"
  resource_id = var.ai_foundry_agent_subnet_resource_id

  body = {
    properties = {
      delegations = [
        {
          name = "Microsoft.App/environments"
          properties = {
            serviceName = "Microsoft.App/environments"
            actions     = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }
      ]
    }
  }
}

resource "azapi_update_resource" "add_subnet_delegation_for_app_service_subnet" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2022-05-01"
  resource_id = var.app_service_subnet_resource_id

  body = {
    properties = {
      delegations = [
        {
          name = "Microsoft.Web/serverFarms"
          properties = {
            serviceName = "Microsoft.Web/serverFarms"
            actions     = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }
      ]
    }
  }
}
