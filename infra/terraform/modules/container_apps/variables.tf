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

variable "user_assigned_identity_resource_id" {
  description = "The resource ID of the user-assigned identity to assign roles to"
  type        = string
}

variable "name" {
  description = "The name of the Container App"
  type        = string
}

variable "container_apps_environment_resource_id" {
  description = "The resource ID of the Container App Environment"
  type        = string
}

variable "container_registry_hostname" {
  description = "The hostname of the Container Registry"
  type        = string
}

variable "ingress" {
  description = "Configuration for ingress settings of the Container App"
  type = object({
    external_enabled = bool
    target_port      = number
  })
}

variable "scale" {
  description = "Configuration for scaling rules of the Container App"
  type = object({
    min_replicas = number
    max_replicas = number
  })
}

variable "containers" {
  description = "List of containers to be deployed in the Container App"
  type = list(object({
    name   = string
    image  = string
    cpu    = number
    memory = string
  }))
}

variable "environment_variables" {
  description = "Environment variables to be set for the containers"
  type = list(object({
    name  = string
    value = string
  }))
}
