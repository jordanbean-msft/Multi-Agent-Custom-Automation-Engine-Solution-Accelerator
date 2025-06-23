module "avm-res-app-containerapp" {
  source                                = "Azure/avm-res-app-containerapp/azurerm"
  version                               = "0.6.0"
  name                                  = var.name
  resource_group_name                   = var.resource_group_name
  tags                                  = var.tags
  revision_mode                         = "Single"
  container_app_environment_resource_id = var.container_apps_environment_resource_id
  workload_profile_name                 = "Consumption"
  managed_identities = {
    user_assigned_resource_ids = [var.user_assigned_identity_resource_id]
  }
  registries = [{
    server   = var.container_registry_hostname
    identity = var.user_assigned_identity_resource_id
  }]
  template = {
    containers = [
      for container in var.containers : {
        name   = container.name
        image  = "${container.image != "" ? container.image : "mcr.microsoft.com/k8se/quickstart:latest"}"
        cpu    = container.cpu
        memory = container.memory
        env    = var.environment_variables
      }
    ]
    min_replicas = var.scale.min_replicas
    max_replicas = var.scale.max_replicas
  }
  ingress = {
    external_enabled = var.ingress.external_enabled
    target_port      = var.containers[0].image != "" ? var.ingress.target_port : 80
    traffic_weight = [{
      latest_revision = true
      percentage      = 100
    }]
  }
}
