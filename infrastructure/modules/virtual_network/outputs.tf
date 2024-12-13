# Localisation Azure
variable "location" {
  description = "La région Azure pour le déploiement"
  default     = "East US"
}

# Nom du groupe de ressources
variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  default     = "vnet-resources"
}

# Nom du Virtual Network
variable "vnet_name" {
  description = "Nom du Virtual Network"
  default     = "vnet-shop-app"
}

# Espace d'adresse du Virtual Network
variable "vnet_address_space" {
  description = "Espace d'adressage CIDR pour le Virtual Network"
  default     = ["10.0.0.0/16"]
}

# Nom et espace d'adresse du sous-réseau pour CosmosDB
variable "cosmosdb_subnet_name" {
  description = "Nom du sous-réseau pour CosmosDB"
  default     = "cosmosdb-subnet"
}

variable "cosmosdb_subnet_prefix" {
  description = "Plage d'adresses CIDR pour le sous-réseau CosmosDB"
  default     = "10.0.1.0/24"
}

# Nom et espace d'adresse du sous-réseau pour App Service
variable "appservice_subnet_name" {
  description = "Nom du sous-réseau pour App Service"
  default     = "appservice-subnet"
}

variable "appservice_subnet_prefix" {
  description = "Plage d'adresses CIDR pour le sous-réseau App Service"
  default     = "10.0.2.0/24"
}
