resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vm_names)
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  for_each              = toset(var.vm_names)
  name                  = each.key
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  vm_size               = "Standard_DC1s_v3"

  storage_os_disk {
    name              = "${each.key}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = each.key
    admin_username = "azureuser"
    admin_password = "Password123!"
    custom_data    = base64encode(file(var.vm_custom_data[each.key]))
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
