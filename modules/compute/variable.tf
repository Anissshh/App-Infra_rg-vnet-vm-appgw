variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_names" {
  type = list(string)
}
variable "vm_custom_data" {
  type = map(string)
  default = {
    vm1 = "streamflix.yml"
    vm2 = "starbucks.yml"
  }
}