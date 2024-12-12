variable "resource_group_name" {
  default = "rg" # Name of the Resource Group
}

variable "location" {
  default = "France Central" # Set to France Central
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "storage_container_name" {
  description = "The name of the storage container"
  type        = string
}

variable "storage_blob_name" {
  description = "The name of the storage blob"
  type        = string
}

variable "storage_blob_source" {
  description = "The source file for the storage blob"
  type        = string
}