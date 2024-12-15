# Fournisseur Azure pour Terraform
# Déclaration du fournisseur Azure (azurerm) utilisé pour interagir avec les services Azure.
provider "azurerm" {
  features {}  # Active toutes les fonctionnalités par défaut du fournisseur Azure.
}

# Configuration globale de Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # Fournisseur officiel Terraform pour Azure.
      version = ">= 4.11.0"          # Version minimale requise du fournisseur Azure.
    }
  }
  required_version = ">= 1.0.0"  # Version minimale de Terraform à utiliser pour cette configuration.
}

# Module pour le groupe de ressources
# Ce module crée un groupe de ressources dans Azure pour regrouper toutes les ressources.
module "resource_group" {
  source              = "./modules/resource_group"  # Chemin vers le module local pour le groupe de ressources.
  prefix              = var.prefix                  # Préfixe pour nommer les ressources.
  location            = var.location                # Région Azure où déployer les ressources.
  resource_group_name = var.resource_group_name     # Nom du groupe de ressources.
}

# Module pour le Virtual Network
# Ce module crée un réseau virtuel (VNet) et ses sous-réseaux dans Azure.
module "virtual_network" {
  source                  = "./modules/virtual_network"  # Chemin vers le module local pour le Virtual Network.
  vnet_name               = var.vnet_name               # Nom du réseau virtuel.
  address_space           = var.address_space           # Plage d'adresses IP du réseau virtuel.
  location                = module.resource_group.location  # Région Azure (héritée du groupe de ressources).
  resource_group_name     = module.resource_group.resource_group_name  # Groupe de ressources où déployer le VNet.
  subnet_name             = var.subnet_name             # Nom du sous-réseau principal.
  subnet_address_prefixes = var.subnet_address_prefixes  # Plage d'adresses IP pour le sous-réseau.
}

# Module pour CosmosDB
# Ce module configure un compte CosmosDB, une base de données et ses conteneurs.
module "cosmosdb" {
  source                = "./modules/cosmosdb"           # Chemin vers le module local pour CosmosDB.
  location              = module.resource_group.location  # Région Azure (héritée du groupe de ressources).
  resource_group_name   = module.resource_group.resource_group_name  # Groupe de ressources pour CosmosDB.
  cosmosdb_account_name = var.cosmosdb_account_name      # Nom du compte CosmosDB.
  database_name         = var.database_name             # Nom de la base de données CosmosDB.
  cosmosdb_subnet_id    = module.virtual_network.app_service_subnet_id  # ID du sous-réseau pour CosmosDB.
}

# Module pour le Blob Storage
# Ce module configure un compte de stockage Azure Blob et un conteneur associé.
module "blob_storage" {
  source               = "./modules/blob_storage"         # Chemin vers le module local pour Blob Storage.
  location             = module.resource_group.location    # Région Azure (héritée du groupe de ressources).
  resource_group_name  = module.resource_group.resource_group_name  # Groupe de ressources pour Blob Storage.
  storage_account_name = var.storage_account_name          # Nom du compte de stockage.
  container_name       = var.container_name               # Nom du conteneur Blob.
}

# Module pour App Service
# Ce module déploie un App Service pour exécuter une application web avec une image Docker.
module "app_service" {
  source                 = "./modules/app_service"         # Chemin vers le module local pour App Service.
  prefix                 = var.prefix                      # Préfixe pour nommer les ressources.
  region                 = var.location                    # Région Azure pour l'App Service.
  resource_group         = module.resource_group.resource_group_name  # Groupe de ressources pour App Service.
  subnet_id              = module.virtual_network.app_service_subnet_id  # ID du sous-réseau utilisé par App Service.
  cosmosdb_db_name       = module.cosmosdb.database_name   # Nom de la base de données CosmosDB utilisée.
  cosmosdb_container_name = var.cosmosdb_container_name    # Nom du conteneur CosmosDB utilisé.
  cosmosdb_key           = module.cosmosdb.cosmosdb_primary_key  # Clé d'accès au compte CosmosDB.
  cosmosdb_url           = module.cosmosdb.cosmosdb_endpoint  # Endpoint du compte CosmosDB.
  api_secret             = var.api_secret                 # Clé secrète API pour sécuriser l'application.
  docker_user            = var.docker_user                # Identifiant du registre Docker.
  docker_pass            = var.docker_pass                # Mot de passe du registre Docker.
  docker_image           = var.docker_image               # Nom et tag de l'image Docker utilisée pour l'application.
}
