variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnets" {
  type = map(string)
}

variable "vm_names" {
  type = list(string)
}
variable "backend_ips" {
  type = list(string)
}


variable "resource_group_name" {
  default = "resource1"
}


