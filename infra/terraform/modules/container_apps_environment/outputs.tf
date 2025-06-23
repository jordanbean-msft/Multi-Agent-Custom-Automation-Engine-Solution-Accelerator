output "container_apps_environment_id" {
  description = "The ID of the Container Apps Environment"
  value       = module.avm-res-app-managedenvironment.resource_id
}

output "container_apps_environment_name" {
  description = "The name of the Container Apps Environment"
  value       = module.avm-res-app-managedenvironment.name
}
