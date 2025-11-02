resource "random_string" "swa" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_static_web_app" "swa" {
  name                = "${var.name_prefix}-${var.env}-swa-${random_string.swa.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = "Free"
  sku_size            = "Free"
  tags                = var.tags
}
