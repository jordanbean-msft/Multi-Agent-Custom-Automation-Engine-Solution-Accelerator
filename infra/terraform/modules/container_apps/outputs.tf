output "container_apps_resource_id" {
  description = "The resource ID of the Azure Container Apps"
  value       = module.avm-res-app-containerapp.resource_id
}

output "container_apps_name" {
  description = "The name of the Azure Container Apps"
  value       = module.avm-res-app-containerapp.resource.name
}

output "container_apps_fqdn_url" {
  description = "The FQDN of the Azure Container Apps"
  value       = module.avm-res-app-containerapp.fqdn_url
}
