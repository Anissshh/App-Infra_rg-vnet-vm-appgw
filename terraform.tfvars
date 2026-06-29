# Resource Group
rg_name  = "resource1"
location = "centralindia"

# Subnets
subnets = {
  web                = "10.0.1.0/24"
  app                = "10.0.2.0/24"
  db                 = "10.0.3.0/24"
  AzureBastionSubnet = "10.0.4.0/26"   # Bastion ke liye fixed naam
  appgw-subnet       = "10.0.5.0/24"   # Application Gateway ke liye
}

# VM Names
vm_names = ["vm1", "vm2"]

backend_ips = ["10.0.1.4", "10.0.1.5"]
