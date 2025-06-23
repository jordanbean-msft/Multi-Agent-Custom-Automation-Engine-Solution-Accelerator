output "container_registry_id" {
  description = "The ID of the Azure Container Registry"
  value       = module.avm-res-containerregistry-registry.resource_id
}

output "container_registry_name" {
  description = "The name of the Azure Container Registry"
  value       = module.avm-res-containerregistry-registry.name
}

output "container_registry_login_server" {
  description = "The login server of the Azure Container Registry"
  value       = module.avm-res-containerregistry-registry.resource.login_server
}
