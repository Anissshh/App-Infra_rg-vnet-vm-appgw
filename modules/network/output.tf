output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_names" {
  value = [for s in azurerm_subnet.subnets : s.name]
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}

output "subnet_ids" {
  value = {
    for s in azurerm_subnet.subnets :
    s.name => s.id
  }
}
