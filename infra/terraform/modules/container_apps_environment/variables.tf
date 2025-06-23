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

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the Storage Account"
  type        = bool
}

variable "user_assigned_identity_principal_id" {
  description = "The principal ID of the user-assigned identity to assign roles to"
  type        = string
}

variable "container_apps_subnet_resource_id" {
  description = "The resource ID of the subnet for Container Apps"
  type        = string
}

variable "log_analytics_workspace_resource_id" {
  description = "The ID of the Log Analytics Workspace to link with Container Apps"
  type        = string
}

variable "log_analytics_workspace_customer_id" {
  description = "The customer ID of the Log Analytics Workspace"
  type        = string
}

variable "log_analytics_workspace_primary_shared_key" {
  description = "The primary key of the Log Analytics Workspace"
  type        = string
}

variable "workload_profile_type" {
  description = "The type of workload profile for the Container Apps environment"
  type        = string
}

variable "minimum_count" {
  description = "Minimum number of replicas for the Container Apps"
  type        = number
}

variable "maximum_count" {
  description = "Maximum number of replicas for the Container Apps"
  type        = number
}
