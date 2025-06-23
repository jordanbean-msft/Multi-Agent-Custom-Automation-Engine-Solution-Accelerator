variable "private_endpoint_subnet_resource_id" {
  description = "The resource ID of the subnet where the private endpoint will be created"
  type        = string
}

variable "container_apps_subnet_resource_id" {
  description = "The resource ID of the subnet for Container Apps"
  type        = string
}

variable "ai_foundry_agent_subnet_resource_id" {
  description = "The resource ID of the subnet for the AI Foundry agent"
  type        = string
}

variable "app_service_subnet_resource_id" {
  description = "The resource ID of the subnet for App Service"
  type        = string
}
