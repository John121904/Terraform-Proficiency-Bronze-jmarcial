# Create App Service
resource "azurerm_linux_web_app" "app_service" {
  count = var.instance_count

  name                = "${var.webapp}${count.index + 1}"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = var.asp_id

  site_config {}
}