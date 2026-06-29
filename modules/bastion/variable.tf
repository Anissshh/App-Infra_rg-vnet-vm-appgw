variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "bastion_subnet_id" {
  type        = string
  description = "ID of the Bastion subnet"
}
