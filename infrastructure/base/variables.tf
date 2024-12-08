variable "location" {
  description = "Azure region for the backend infrastructure"
  type        = string
  default     = "francecentral"
}

variable "tfstate_rg_name" {
  description = "Name of the resource group for the Terraform state backend"
  type        = string
  default     = "juniashop-rg"
}

variable "tfstate_sa_name" {
  description = "Name prefix of the storage account for the Terraform state"
  type        = string
  default     = "juniashop"
}

variable "tfstate_container_name" {
  description = "Name of the storage container for the Terraform state"
  type        = string
  default     = "tfstate"
}

variable "github_action_user_name_prefix" {
  description = "Prefix for the GitHub Action User principal name (the random suffix will be added)"
  type        = string
  default     = "githubactionuser"
}

variable "azure_tenant_domain" {
  description = "Azure tenant domain name, typically 'yourtenant.onmicrosoft.com'"
  type        = string
}
