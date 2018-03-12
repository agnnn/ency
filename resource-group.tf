# Resource Group
resource "azurerm_resource_group" "functions" {
  name     = "${var.resource_group}"
  location = "${var.region}"
}
