resource "azurerm_application_insights" "appi" {
  name                = "${var.name_prefix}-${var.env}-appi"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  application_type    = "web"
  tags                = var.tags
}
