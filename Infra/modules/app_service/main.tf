resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-${var.env}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.name_prefix}-${var.env}-api"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      docker_image_name   = "${var.image_name}:${var.image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    always_on                               = true
    container_registry_use_managed_identity = true

  }


  app_settings = {
    WEBSITES_PORT                         = var.container_port
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_str
    DB_SERVER                             = var.sql_server_fqdn
    DB_NAME                               = var.sql_database_name
  }

  tags = var.tags
}

# VNet Integration
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_web_app.app.id
  subnet_id      = var.backend_subnet_id
}
