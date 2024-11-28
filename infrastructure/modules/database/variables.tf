variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

variable "vnet_id" {
    description = "The ID of the virtual network"
    type        = string
}

variable "database_subnet_id" {
    description = "The ID of the database subnet"
    type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone"
  type        = string
}

variable "dns_zone_link_name" {
  description = "The name of the DNS zone link"
  type        = string
}

variable "database_admin_username" {
  description = "The username of the database admin"
  type        = string
  sensitive   = true
}

variable "database_admin_password" {
  description = "The password of the database admin"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the database"
  type        = string
}

variable "server_name" {
  description = "The name of the database server"
  type        = string
}