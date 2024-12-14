# Création d'un compte de stockage Azure
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name       # Nom du compte de stockage
  resource_group_name      = var.resource_group_name        # Groupe de ressources associé
  location                 = var.location                   # Localisation
  account_kind             = "StorageV2"                   # Type de compte de stockage (StorageV2 - généraliste)
  account_tier             = "Standard"                    # Niveau de performance (Standard)
  account_replication_type = "LRS"                         # Type de réplication (Local Redundant Storage - LRS)
}

# Création d'un conteneur de stockage dans le compte de stockage
resource "azurerm_storage_container" "storage_container" {
  name                  = var.container_name               # Nom du conteneur de stockage
  storage_account_name  = azurerm_storage_account.storage_account.name # Nom du compte de stockage associé
  container_access_type = "private"                        # Type d'accès (privé, pas d'accès public)
}

# Chargement d'un fichier JSON dans le conteneur de stockage
resource "azurerm_storage_blob" "json_blob" {
  name                   = "quotes.json"                   # Nom du fichier blob (le fichier chargé dans le conteneur)
  storage_account_name   = azurerm_storage_account.storage_account.name # Nom du compte de stockage associé
  storage_container_name = azurerm_storage_container.storage_container.name # Nom du conteneur de stockage associé
  type                   = "Block"                         # Type de blob (Block blob, pour fichiers binaires ou texte)
  source                 = "../quotes/quotes.json"         # Chemin local vers le fichier source à charger
}