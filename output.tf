output "rg_name" {
  value = module.rg.name
}

output "rg_location" {
  value = module.rg.location
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_names" {
  value = module.network.subnet_names
}

output "nsg_name" {
  value = module.network.nsg_name
}
output "nic_private_ips" {
  value = module.compute.nic_private_ips
}

output "nic_ids" {
  value = module.compute.nic_ids
}

output "appgw_public_ip" {
  value = module.appgw.appgw_public_ip
}

