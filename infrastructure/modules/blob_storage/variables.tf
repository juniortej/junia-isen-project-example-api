variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "storage_subnet_id" {
  type        = string
  default     = null
  description = "The ID of the subnet that is used by the storage account"
}

variable "ip_authorized" {
  description = "The IP address that is authorized to access the storage account"
  type        = string
}