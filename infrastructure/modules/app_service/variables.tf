variable "prefix" {
  description = "Préfixe pour nommer toutes les ressources"
  type        = string
}

variable "region" {
  description = "Région Azure pour le déploiement"
  type        = string
}

variable "resource_group" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "docker_image" {
  description = "Nom et tag de l'image Docker (ex: user/app:latest)"
  type        = string
}

variable "subnet_id" {
  description = "ID du sous-réseau pour l'App Service"
  type        = string
}

variable "api_secret" {
  description = "Clé secrète API utilisée par l'application"
  type        = string
}

variable "cosmosdb_url" {
  description = "Endpoint CosmosDB"
  type        = string
}

variable "cosmosdb_key" {
  description = "Clé d'accès CosmosDB"
  type        = string
  sensitive   = true
}

variable "cosmosdb_db_name" {
  description = "Nom de la base de données CosmosDB"
  type        = string
}

variable "cosmosdb_container_name" {
  description = "Nom du conteneur CosmosDB"
  type        = string
}

variable "docker_user" {
  description = "Utilisateur du registre Docker"
  type        = string
}

variable "docker_pass" {
  description = "Mot de passe du registre Docker"
  type        = string
  sensitive   = true
}


