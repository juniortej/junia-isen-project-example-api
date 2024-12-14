terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.60"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "tls" {}

provider "random" {}
