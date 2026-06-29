resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-host"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "bastion-ipcfg"
    subnet_id            = var.bastion_subnet_id   # ✅ ye root se pass hoga
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
