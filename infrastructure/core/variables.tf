# infrastructure/core/variables.tf

variable "base_rg_name" {
  description = "The name of the general base Resource Group."
  type        = string
  default     = "juniashop-rg"
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "francecentral"
}

variable "developer_object_id" {
  description = "The Object ID of the Developer SP for role assignment."
  type        = string
}

variable "owner_object_id" {
  description = "The Object ID of the Owner SP for role assignment."
  type        = string
}
