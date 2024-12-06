provider "azurerm" {
  features {}
}

module "app_service_test" {
  source = "../../modules/app_service"
  app_service_name     = "test-app"
  location             = "East US"
  resource_group_name  = "test-rg"
  app_service_plan_id  = "test-plan-id"
}
