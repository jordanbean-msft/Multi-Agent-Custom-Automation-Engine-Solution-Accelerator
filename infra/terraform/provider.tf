# Configure the Azure Provider
terraform {
  required_version = ">= 1.1.7, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 5.0.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.4.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {
  }
}

# Make client_id, tenant_id, subscription_id and object_id variables
data "azurerm_client_config" "current" {}
