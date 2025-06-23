output "private_endpoint_subnet_resource_id" {
  description = "The resource ID of the subnet for the private endpoint"
  value       = var.private_endpoint_subnet_resource_id
}

output "container_apps_subnet_resource_id" {
  description = "The resource ID of the subnet for the Container Apps"
  value       = var.container_apps_subnet_resource_id
}

output "ai_foundry_agent_subnet_resource_id" {
  description = "The resource ID of the subnet for the AI Foundry agent"
  value       = var.ai_foundry_agent_subnet_resource_id
}

output "app_service_subnet_resource_id" {
  description = "The resource ID of the subnet for App Service"
  value       = var.app_service_subnet_resource_id
}
