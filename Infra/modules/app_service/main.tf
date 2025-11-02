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

  identity { type = "SystemAssigned" }

  site_config {
    application_stack { node_version = "18-lts" }
    always_on = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = "false"
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_str
    # Example connection string (use Key Vault in real life)
    DB_SERVER = var.sql_server_fqdn
    DB_NAME   = var.sql_database_name
    # Use Managed Identity + AAD auth for production
  }

  tags = var.tags
}

# VNet integration (to reach SQL private endpoint)
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_web_app.app.id
  subnet_id      = var.backend_subnet_id
}
