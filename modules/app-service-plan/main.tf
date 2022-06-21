# Create App Service plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = var.asp_name
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}