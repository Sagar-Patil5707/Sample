output "vnet_id" { value = azurerm_virtual_network.vnet.id }
output "backend_subnet_id" { value = azurerm_subnet.backend.id }
output "data_subnet_id" { value = azurerm_subnet.data.id }
output "nsg_ids" { value = [
  azurerm_network_security_group.nsg_frontend.id,
  azurerm_network_security_group.nsg_backend.id,
  azurerm_network_security_group.nsg_data.id
] }
