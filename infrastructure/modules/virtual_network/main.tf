# Définition du réseau virtuel (Virtual Network - VNet) dans Azure
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name           # Nom du réseau virtuel
  address_space       = var.address_space       # Espace d'adressage pour le VNet (ex: "10.0.0.0/16")
  location            = var.location            # Localisation du réseau virtuel
  resource_group_name = var.resource_group_name # Groupe de ressources associé
}

# Sous-réseau dédié aux App Services
resource "azurerm_subnet" "app_service_subnet" {
  name                 = "subnet-app-service"   # Nom du sous-réseau
  resource_group_name  = var.resource_group_name # Groupe de ressources associé
  virtual_network_name = azurerm_virtual_network.vnet.name # Nom du réseau virtuel auquel ce sous-réseau appartient
  address_prefixes     = ["10.0.2.0/24"]        # Plage d'adresses pour ce sous-réseau

  # Délégation de sous-réseau pour permettre l'intégration avec App Services
  delegation {
    name = "delegation"                         # Nom de la délégation
    service_delegation {
      name = "Microsoft.Web/serverFarms"        # Type de service délégué (App Service Plan)
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action" # Actions autorisées
      ]
    }
  }
}

# Sous-réseau dédié aux bases de données PostgreSQL flexibles
resource "azurerm_subnet" "postgresql_subnet" {
  name                 = "subnet-postgresql"    # Nom du sous-réseau
  resource_group_name  = var.resource_group_name # Groupe de ressources associé
  virtual_network_name = azurerm_virtual_network.vnet.name # Nom du réseau virtuel auquel ce sous-réseau appartient
  address_prefixes     = ["10.0.3.0/24"]        # Plage d'adresses pour ce sous-réseau

  # Délégation de sous-réseau pour permettre l'intégration avec PostgreSQL flexible
  delegation {
    name = "delegation"                         # Nom de la délégation
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers" # Type de service délégué (PostgreSQL flexible servers)
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action" # Actions autorisées
      ]
    }
  }
}

# Zone DNS privée pour PostgreSQL
resource "azurerm_private_dns_zone" "postgresql_dns_zone" {
  name                = "privatelink.postgres.database.azure.com" # Nom de la zone DNS privée
  resource_group_name = var.resource_group_name # Groupe de ressources associé
}

# Liaison entre la zone DNS privée et le réseau virtuel
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_dns_link" {
  name                  = "vnet-link"                     # Nom de la liaison
  resource_group_name   = var.resource_group_name         # Groupe de ressources associé
  private_dns_zone_name = azurerm_private_dns_zone.postgresql_dns_zone.name # Nom de la zone DNS privée
  virtual_network_id    = azurerm_virtual_network.vnet.id # ID du réseau virtuel à lier
}