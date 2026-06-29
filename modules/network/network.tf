resource "azurerm_virtual_network" "vnet" {
  name                = "main-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key   # jo key tum map me doge wahi subnet ka naam hoga
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}


# resource "azurerm_subnet" "subnets" {
#   for_each             = var.subnets
#   name                 = each.key
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = [each.value]
# }

# resource "azurerm_subnet" "subnets" {
#   for_each             = var.subnets
#   name                 = each.key == "bastion" ? "AzureBastionSubnet" : "${each.key}-subnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = [each.value]
# }


resource "azurerm_network_security_group" "nsg" {
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
  name                       = "Allow-HTTP"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

security_rule {
  name                       = "Allow-HTTPS"
  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

security_rule {
  name                       = "Allow-SSH"
  priority                   = 120
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each = {
    for k, v in azurerm_subnet.subnets : k => v if !contains(["appgw-subnet", "AzureBastionSubnet"], k)
  }

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

