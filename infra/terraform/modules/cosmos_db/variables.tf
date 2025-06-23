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
  description = "The ID of the Log Analytics Workspace to link with Cosmos DB"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the Cosmos DB account"
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

variable "document_time_to_live" {
  description = "Default time to live for documents in the Cosmos DB account"
  type        = number
}

variable "max_throughput" {
  description = "Maximum throughput for the Cosmos DB account"
  type        = number
}

variable "zone_redundancy_enabled" {
  description = "Enable or disable zone redundancy for the Cosmos DB account"
  type        = bool
}

variable "subscription_id" {
  description = "The Azure subscription ID where the Cosmos DB account will be created"
  type        = string
}
