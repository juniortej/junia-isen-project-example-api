# L'ID complet de l'App Service
output "app_service_id" {
  description = "L'ID complet de l'App Service"
  value       = azurerm_linux_web_app.web_app.id
}

# URL publique par défaut de l'App Service
output "app_service_default_hostname" {
  description = "L'URL par défaut de l'App Service"
  value       = azurerm_linux_web_app.web_app.default_site_hostname
}

# L'ID du plan de service associé
output "app_service_plan_id" {
  description = "L'ID du plan de service Azure App Service"
  value       = azurerm_service_plan.service_plan.id
}

# Nom du groupe de ressources pour vérification
output "resource_group_name" {
  description = "Nom du groupe de ressources dans lequel l'App Service est déployé"
  value       = var.resource_group
}
