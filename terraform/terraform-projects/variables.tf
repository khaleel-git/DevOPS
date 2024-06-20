# variables.tf

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "ODL-azure-1288273"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  default     = "khaleel-unix-vnet"
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "default"
}

variable "public_ip_name" {
  description = "Name of the public IP address"
  default     = "khaleel-unix-public-ip"
}

variable "network_interface_name" {
  description = "Name of the network interface"
  default     = "khaleel-unix-nic"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  default     = "khaleel-unix-vm"
}

variable "admin_username" {
  description = "Admin username for the VM"
  default     = "khaleel-unix"
}

variable "admin_password" {
  description = "Admin password for the VM"
  default     = "Id35202@mS.ubuntU"
}

variable "location" {
  description = "Azure region where resources will be created"
  default     = "Australia Southeast"
}

variable "vm_size" {
  description = "Size of the VM"
  default     = "Standard_D2s_v3"
}
