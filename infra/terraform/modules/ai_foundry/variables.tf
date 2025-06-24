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

variable "ai_foundry_agent_subnet_resource_id" {
  description = "The resource ID of the subnet for the AI Foundry agent"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled"
  type        = bool
}

variable "log_analytics_workspace_resource_id" {
  description = "The resource ID of the Log Analytics workspace for diagnostic settings"
  type        = string
}

# variable "user_assigned_identity_principal_id" {
#   description = "The principal ID of the user-assigned identity for role assignments"
#   type        = string
# }

variable "user_assigned_identity_id" {
  description = "The ID of the user-assigned identity for role assignments"
  type        = string
}

variable "user_assigned_identity_client_id" {
  description = "The client ID of the user-assigned identity for role assignments"
  type        = string
}

variable "storage_account_resource_id" {
  description = "The resource ID of the storage account for AI Foundry"
  type        = string
}

variable "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account for AI Foundry"
  type        = string
}

variable "cosmos_db_account_resource_id" {
  description = "The resource ID of the Cosmos DB account for AI Foundry"
  type        = string
}

variable "ai_search_resource_id" {
  description = "The resource ID of the AI Search account for AI Foundry"
  type        = string
}

variable "ai_search_name" {
  description = "The name of the AI Search account for AI Foundry"
  type        = string
}

variable "cosmos_db_account_document_endpoint" {
  description = "The document endpoint of the Cosmos DB account for AI Foundry"
  type        = string
}

variable "private_endpoint_subnet_resource_id" {
  description = "The resource ID of the private endpoint subnet for AI Foundry"
  type        = string
}

variable "model_sku_name" {
  description = "The SKU name for the AI Foundry model"
  type        = string
}

variable "model_sku_capacity" {
  description = "The SKU capacity for the AI Foundry model"
  type        = number
}

variable "model_format" {
  description = "The format of the AI Foundry model"
  type        = string
}

variable "model_name" {
  description = "The name of the AI Foundry model"
  type        = string
}

variable "model_version" {
  description = "The version of the AI Foundry model"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the AI Foundry account"
  type        = string
}
