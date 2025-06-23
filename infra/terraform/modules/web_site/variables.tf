variable "name_suffix" {
  description = "Suffix for the name of the resources"
  type        = string
}

variable "location" {
  description = "The Azure location to deploy the resources"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "log_analytics_workspace_resource_id" {
  description = "The resource ID of the Log Analytics Workspace"
  type        = string
}

variable "os_type" {
  description = "The operating system type for the Web App"
  type        = string
}

variable "service_plan_resource_id" {
  description = "The resource ID of the App Service Plan"
  type        = string
}

variable "kind" {
  description = "The kind of the Web App (e.g., 'app', 'functionapp')"
  type        = string
}

variable "app_settings" {
  description = "Application settings for the Web App"
  type        = map(string)
}

variable "site_config" {
  description = "Configuration settings for the Web App"
  type = object({
    linux_fx_version = optional(string)
  })
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the Storage Account"
  type        = bool
}

variable "private_endpoint_subnet_resource_id" {
  description = "The resource ID of the subnet for the private endpoint"
  type        = string
}

variable "app_service_subnet_resource_id" {
  description = "The resource ID of the subnet for the App Service"
  type        = string
}
