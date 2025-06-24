variable "location" {
  description = "The Azure location to deploy the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "environment_name" {
  description = "The name of the environment, used for tagging and resource naming"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the resources"
  type        = bool
}

variable "principal_id" {
  description = "The principal ID of the user to assign roles to"
  type        = string
}

variable "cosmos_db" {
  description = "Configuration for the Cosmos DB account"
  type = object({
    document_time_to_live = number,
    max_throughput        = number,
  })
}

variable "storage_account" {
  description = "Configuration for the Storage Account"
  type = object({
    account_tier             = string,
    account_replication_type = string,
  })
}

variable "container_apps" {
  description = "Configuration for the Container Apps"
  type = object({
    workload_profile_type = string,
    minimum_count         = number,
    maximum_count         = number,
    backend = object({
      name = string,
      containers = list(object({
        name   = string,
        image  = string
        cpu    = number,
        memory = string
      })),
      ingress = object({
        external_enabled = bool,
        target_port      = number
      }),
      scale = object({
        min_replicas = number,
        max_replicas = number,
      }),
    }),
  })
}

variable "network" {
  description = "Network configuration for the resources"
  type = object({
    virtual_network_name         = string
    private_endpoint_subnet_name = string
    container_apps_subnet_name   = string
    ai_foundry_agent_subnet_name = string
    app_service_subnet_name      = string
  })
}

variable "ai_foundry" {
  description = "Configuration for the AI Foundry resources"
  type = object({
    sku_name = string,
    model = object({
      sku_name     = string,
      sku_capacity = number,
      format       = string,
      name         = string,
      version      = string
    })
  })
}

variable "zone_redundancy_enabled" {
  description = "Enable or disable zone redundancy for the Cosmos DB account"
  type        = bool
}

variable "web_site" {
  description = "Configuration for the Web Site"
  type = object({
    sku_name   = string,
    image_name = string
  })
}


