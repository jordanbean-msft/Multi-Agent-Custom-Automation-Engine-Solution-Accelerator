output "app_service_plan_resource_id" {
  description = "The ID of the App Service Plan"
  value       = module.avm-res-web-serverfarm.resource_id
}

output "app_service_plan_name" {
  description = "The name of the App Service Plan"
  value       = module.avm-res-web-serverfarm.name
}
