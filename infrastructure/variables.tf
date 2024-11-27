variable "resource_group_name" {
  default = "API-shop-app-cc-junia"
}

variable "location" {
  default = "France Central"
}

variable "app_service_name" {
  default = "shop-app-service-cc-clemclem"
}

variable "database_name" {
  default = "shop-app-cc-junia-db"
}

variable "vnet_address_space" {
  default = "10.0.0.0/16"
}

variable "subnet_app_service" {
  default = "10.0.1.0/24"
}

variable "subnet_cosmosdb" {
  default = "10.0.2.0/24"
}

variable "docker_registry_username" {} 
variable "docker_registry_password" {}
variable "subscription_id" {}
variable "api_key" {}


