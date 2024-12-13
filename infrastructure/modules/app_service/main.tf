# Crée un plan de service Azure App Service pour exécuter des applications Linux
resource "azurerm_service_plan" "service_plan" {
  name                = "${var.prefix}-plan"
  location            = var.region
  resource_group_name = var.resource_group
  os_type             = "Linux"
  sku_name = "B1"
}

# Déploie une application web basée sur Docker avec un App Service
resource "azurerm_linux_web_app" "web_app" {
  name                = "${var.prefix}-app"
  location            = var.region
  resource_group_name = var.resource_group
  service_plan_id     = azurerm_service_plan.service_plan.id

  # Force l'utilisation de HTTPS pour sécuriser l'application
  https_only = true

  # Configuration des conteneurs Docker
  site_config {
    always_on = true
    linux_fx_version = "DOCKER|${var.docker_image}" # Utilisation de l'image Docker définie dans les variables

    # Configurations réseau (ajout au VNet)
    vnet_route_all_enabled    = true
  }

  virtual_network_subnet_id = var.subnet_id

  # Variables d'environnement nécessaires à l'application
  app_settings = {
    "APP_ENV"                 = "production"
    "API_SECRET_KEY"          = var.api_secret
    "COSMOSDB_URL"            = var.cosmosdb_url
    "COSMOSDB_KEY"            = var.cosmosdb_key
    "COSMOSDB_DATABASE"       = var.cosmosdb_db_name
    "COSMOSDB_CONTAINER"      = var.cosmosdb_container_name
    "DOCKER_REGISTRY_USERNAME" = var.docker_user
    "DOCKER_REGISTRY_PASSWORD" = var.docker_pass
  }

  # Désactive l'affinité client (pas besoin de sticky sessions)
  client_affinity_enabled = false
}


