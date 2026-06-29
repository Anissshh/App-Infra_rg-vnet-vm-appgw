module "rg" {
  source   = "./modules/resource_group"
  rg_name  = var.rg_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = module.rg.name
  location            = module.rg.location
  subnets             = var.subnets
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = module.rg.name
  location            = module.rg.location
  subnet_id           = module.network.subnet_ids["web"]   # ✅ web subnet
  vm_names            = var.vm_names
}

module "appgw" {
  source              = "./modules/appgw"
  resource_group_name = module.rg.name
  location            = module.rg.location
  subnet_id           = module.network.subnet_ids["appgw-subnet"]   # ✅ key match
  backend_ips         = [
    module.compute.nic_private_ips["vm1"],
    module.compute.nic_private_ips["vm2"]
  ]
}

module "bastion" {
  source              = "./modules/bastion"
  location            = var.location
  resource_group_name = module.rg.name
  bastion_subnet_id   = module.network.subnet_ids["AzureBastionSubnet"]   # ✅ Azure requirement
}
