# Azure Resource Group
resource "azurerm_resource_group" "tillgangfunctions" {
  name     = "${var.resource_group}"
  location = "${var.region}"
}

# Azure Application Service Plan
resource "azurerm_app_service_plan" "tillgangfunctions" {
  name                = "azure-functions-test-service-plan"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Azure Storage Account for functions
resource "azurerm_storage_account" "tillgangfunctions" {
  depends_on               = ["azurerm_app_service_plan.tillgangfunctions"]
  name                     = "${var.storageAcctName}"
  resource_group_name      = "${var.resource_group}"
  location                 = "${var.region}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Azure Functions Application
resource "azurerm_function_app" "tillgangfunctions" {
  depends_on                = ["azurerm_storage_account.tillgangfunctions"]
  name                      = "${var.functionAppName}"
  location                  = "${var.region}"
  resource_group_name       = "${var.resource_group}"
  app_service_plan_id       = "${azurerm_app_service_plan.tillgangfunctions.id}"
  storage_connection_string = "${azurerm_storage_account.tillgangfunctions.primary_connection_string}"

# Interpolate all the Application settings for tillgang below.
  app_settings = {
    "AzureWebJobsSecretStorageType" = "disabled"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "3"
    "DIAGNOSTICS_AZUREBLOBRETENTIONINDAYS" = "1"
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.11.2"
    "SCM_USE_FUNCPACK_BUILD" = "1"
    "FUNCTION_APP_EDIT_MODE" = "readonly"
    "VAULT_URL" = "${var.VAULT_URL}"
    "WEBSITE_DISABLE_MSI" = "${var.WEBSITE_DISABLE_MSI}"
    "NODE_ENV" = "${var.NODE_ENV}"
    "NODE_CONFIG_DIR" = "${var.NODE_CONFIG_DIR}"
    "DOCUMENTDB_DB" = "${var.DOCUMENTDB_DB}"
    "DOCUMENTDB_URL" = "${var.DOCUMENTDB_URL}"
    "DOCUMENTDB_KEY" = "${var.DOCUMENTDB_KEY}"
  }
}
