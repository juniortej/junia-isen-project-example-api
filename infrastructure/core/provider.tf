terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name  = var.tfstate_rg_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = "core.tfstate"
  }
}

provider "azurerm" {
  features {}
}
