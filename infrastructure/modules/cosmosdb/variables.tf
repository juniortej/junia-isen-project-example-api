variable "location" {
  description = "Région Azure pour le déploiement"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
}

variable "cosmosdb_account_name" {
  description = "Nom du compte CosmosDB"
  type        = string
}

variable "database_name" {
  description = "Nom de la base de données dans CosmosDB"
  type        = string
}

variable "cosmosdb_subnet_id" {
  description = "ID du sous-réseau autorisé pour accéder à CosmosDB"
  type        = string
}
