provider "azurerm" {
  features {}
  #ADD YOUR SUBSCRIPTION ID HERE
  subscription_id = ""
}

run "input_validation" {
  command = plan
}

run "setup_resource_group" {
  command = apply

  variables {
    resource_group_name = "shop-app-atnmm"
    location = "France Central"
  }
}

run "test_virtual_network" {
  command = apply

  variables {
    resource_group_name = "shop-app-atnmm"
    resource_group_location = "France Central"
  }

  assert {
    condition = can(module.virtual_network.virtual_network_id)
    error_message = "Virtual network not created"
  }
}

run "test_database" {
  command = apply

  variables {
    resource_group_name = "shop-app-atnmm"
    resource_group_location = "France Central"
  }

  assert {
    condition = can(module.database.db_host)
    error_message = "Database not created"
  }
}

run "test_blob_storage" {
  command = apply

  variables {
    resource_group_name = "shop-app-atnmm"
    resource_group_location = "France Central"
  }

  assert {
    condition = can(module.blob_storage.storage_account_id)
    error_message = "Blob storage not created"
  }
}

run "test_application_gateway" {
  command = apply

  variables {
    resource_group_name = "shop-app-atnmm"
    resource_group_location = "France Central"
  }

  assert {
    condition = can(module.application_gateway.public_ip_address)
    error_message = "Application gateway not created"
  }
}

run "test_app_service" {
  command = apply

  variables {
    resource_group_name = "shop-app-atnmm"
    resource_group_location = "France Central"
    app_service_name = "atnmm-app-service-isenm2cloudproject"  // Modifier ce nom pour qu'il soit unique
  }

  assert {
    condition = can(module.app_service.url)
    error_message = "App service not created"
  }
}