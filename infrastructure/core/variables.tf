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

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "juniashop"
}

variable "git_repo_url" {
  description = "The Git repository URL containing the shop-app and Dockerfile."
  type        = string
  default     = "https://github.com/Amiche02/junia-isen-project-example-api"
}

variable "git_branch" {
  description = "The Git branch to build from."
  type        = string
  default     = "master"
}

variable "context_access_token" {
  description = "GitHub Personal Access Token for accessing the repository."
  type        = string
  sensitive   = true
}

variable "developer_object_id" {
  description = "The Object ID of the Developer SP for role assignment."
  type        = string
}

variable "owner_object_id" {
  description = "The Object ID of the Owner SP for role assignment."
  type        = string
}