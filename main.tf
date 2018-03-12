resource "azurerm_resource_group" "test" {
  name     = "${var.resource_group}"
  location = "${var.region}"
}

resource "azurerm_storage_account" "test" {
  name                     = "${var.storageAcctName}"
  resource_group_name      = "${var.resource_group}"
  location                 = "${var.region}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "test" {
  name                = "azure-functions-test-service-plan"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "test" {
  name                      = "${var.functionAppName}"
  location                  = "${var.region}"
  resource_group_name       = "${var.resource_group}"
  app_service_plan_id       = "${azurerm_app_service_plan.test.id}"
  storage_connection_string = "${azurerm_storage_account.test.primary_connection_string}"

  app_settings = {
    "COSMOSDB_NAME" = "${var.COSMOSDB_NAME}"
    "FUNCTION_APP_EDIT_MODE" = "readonly"
    "AzureWebJobsSecretStorageType" = "disabled"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "3"
    "DIAGNOSTICS_AZUREBLOBRETENTIONINDAYS" = "1"
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.11.2"
    "SCM_USE_FUNCPACK_BUILD" = "1"
    "VAULT_URL" = "${var.VAULT_URL}"
    "hello" = "${var.hello}"
  }
}
