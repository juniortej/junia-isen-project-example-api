# Préfixe pour nommer les ressources
variable "prefix" {
  description = "Préfixe pour nommer toutes les ressources (ex : shop-app)"
  type        = string
}

# Localisation des ressources Azure
variable "location" {
  description = "Région Azure pour le déploiement (ex : East US, West Europe)"
  type        = string
}

# Nom du groupe de ressources
variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
}

# Variables pour le réseau virtuel (Virtual Network)
variable "vnet_name" {
  description = "Nom du Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Plage d'adresses pour le Virtual Network (ex : ['10.0.0.0/16'])"
  type        = list(string)
}

variable "subnet_name" {
  description = "Nom du sous-réseau principal"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Plage d'adresses pour le sous-réseau (ex : ['10.0.1.0/24'])"
  type        = list(string)
}

# Variables pour CosmosDB
variable "cosmosdb_account_name" {
  description = "Nom du compte CosmosDB"
  type        = string
}

variable "database_name" {
  description = "Nom de la base de données CosmosDB"
  type        = string
}

variable "cosmosdb_container_name" {
  description = "Nom du conteneur CosmosDB utilisé dans App Service"
  type        = string
}

# Variables pour le Blob Storage
variable "storage_account_name" {
  description = "Nom du compte de stockage Azure (doit être unique globalement)"
  type        = string
}

variable "container_name" {
  description = "Nom du conteneur Blob Storage"
  type        = string
}

# Variables pour App Service
variable "docker_image" {
  description = "Nom et tag de l'image Docker (ex : user/app:latest)"
  type        = string
}

variable "api_secret" {
  description = "Clé secrète API utilisée par l'application"
  type        = string
}

variable "docker_user" {
  description = "Nom d'utilisateur pour le registre Docker"
  type        = string
}

variable "docker_pass" {
  description = "Mot de passe pour le registre Docker"
  type        = string
  sensitive   = true
}
