variable "storage_account_name" {
  description = "The name of the Azure Storage Account. Must be globally unique, between 3 and 24 characters, and only contain lowercase letters and numbers."
  type        = string
}


variable "resource_group_name" {
  description = "The name of the Azure resource group where the storage account will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account will be deployed."
  type        = string
}

variable "container_name" {
  description = "The name of the Azure Storage Container to be created."
  type        = string
}