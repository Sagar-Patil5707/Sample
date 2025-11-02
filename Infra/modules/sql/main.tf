resource "random_string" "sql" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_mssql_server" "server" {
  name                         = "${var.name_prefix}-${var.env}-sql-${random_string.sql.result}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  identity { type = "SystemAssigned" }
  tags = var.tags
}

resource "azurerm_mssql_database" "db" {
  name           = "${var.name_prefix}_${var.env}_db"
  server_id      = azurerm_mssql_server.server.id
  sku_name       = "S0"
  zone_redundant = false
  tags           = var.tags
}

# Private DNS zone for SQL
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.private_dns_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "sql-zone-link"
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  resource_group_name   = var.private_dns_rg_name
  virtual_network_id    = var.vnet_id
}

# Private Endpoint in data subnet
resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name_prefix}-${var.env}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "sql-priv-conn"
    private_connection_resource_id = azurerm_mssql_server.server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }

  tags = var.tags
}
