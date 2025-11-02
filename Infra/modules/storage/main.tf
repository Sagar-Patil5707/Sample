resource "random_string" "sa" {
  length  = 12
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.name_prefix}${var.env}${random_string.sa.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "logs" {
  name                  = "dev-logs"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups" {
  name                  = "dev-backups"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
