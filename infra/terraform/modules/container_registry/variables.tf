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
  description = "The ID of the Log Analytics Workspace to link with Container Registry"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the Container Registry"
  type        = bool
}

variable "user_assigned_identity_principal_id" {
  description = "The principal ID of the user-assigned identity to assign roles to"
  type        = string
}

variable "private_endpoint_subnet_resource_id" {
  description = "The resource ID of the subnet where the private endpoint will be created"
  type        = string
}

variable "zone_redundancy_enabled" {
  description = "Enable or disable zone redundancy for the Container Registry"
  type        = bool
}
