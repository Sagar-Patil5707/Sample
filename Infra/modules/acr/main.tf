resource "azurerm_container_registry" "acr" {
  name                   = "${var.name_prefix}${var.env}acr"
  resource_group_name    = var.resource_group_name
  location               = var.location
  sku                    = "Basic"
  admin_enabled          = false
  anonymous_pull_enabled = false
  tags                   = var.tags
}

# Allow App Service (Managed Identity) to pull images
# resource "azurerm_role_assignment" "acr_pull" {
#   scope                = azurerm_container_registry.acr.id
#   role_definition_name = "AcrPull"
#   principal_id         = var.app_service_mi_principal_id
# }


