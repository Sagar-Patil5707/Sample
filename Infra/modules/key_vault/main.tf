resource "azurerm_key_vault" "kv" {
  name                       = "${var.name_prefix}-${var.env}-kv07"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.allowed_public_ips
  }

  tags = var.tags
}

data "azurerm_client_config" "current" {}
