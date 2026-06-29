resource "azurerm_public_ip" "appgw_pip" {
  name                = "appgw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ipcfg"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "appgw-feip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
    probe_name            = "http-probe"
  }

  # Listeners
  http_listener {
    name                           = "streamflix-listener"
    frontend_ip_configuration_name = "appgw-feip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_name                      = "streamflix.b18g142.online"
  }

  http_listener {
    name                           = "starbucks-listener"
    frontend_ip_configuration_name = "appgw-feip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_name                      = "starbucks.b18g142.online"
  }

  # Backend pools
  backend_address_pool {
    name         = "streamflix-backend"
    ip_addresses = ["10.0.1.4"] # VM1 private IP
  }

  backend_address_pool {
    name         = "starbucks-backend"
    ip_addresses = ["10.0.1.5"] # VM2 private IP
  }

  # Routing rules
  request_routing_rule {
    name                       = "streamflix-rule"
    rule_type                  = "Basic"
    http_listener_name         = "streamflix-listener"
    backend_address_pool_name  = "streamflix-backend"
    backend_http_settings_name = "http-settings"
    priority                   = 101
  }

  request_routing_rule {
    name                       = "starbucks-rule"
    rule_type                  = "Basic"
    http_listener_name         = "starbucks-listener"
    backend_address_pool_name  = "starbucks-backend"
    backend_http_settings_name = "http-settings"
    priority                   = 102
  }

  probe {
  name                = "http-probe"
  protocol            = "Http"
  path                = "/"
  interval            = 30
  timeout             = 30
  unhealthy_threshold = 3
  host                = "localhost"   # ✅ fix
}

}
