variable "app_service_name" {
  description = "The name of the App Service"
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

variable "app_settings" {
  description = "The app service settings"
  default = {}
  type = map(string)
}

variable "gateway_ip" {
  description = "The IP address of the gateway"
  type        = string
}

variable "subnet_id" {
  description = "The id of subnet"
  type        = string
}

variable "docker_image" {
  type = string
  nullable = false
  default = "test"
}

variable "docker_registry_url" {
  type = string
  default = "https://index.docker.io"
}
