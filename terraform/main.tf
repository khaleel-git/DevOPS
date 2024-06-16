data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create public IP address
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = var.location
  allocation_method   = "Dynamic"
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = data.azurerm_resource_group.existing_rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false # Enable password authentication

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  # Define the connection settings for the provisioner
  connection {
    type     = "ssh"
    host     = azurerm_linux_virtual_machine.vm.public_ip_address
    user     = "khaleel-unix"
    password = "Id35202@mS.ubuntU"
  }
  # Define provisioner to run commands after VM creation
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python3-pip",
      "pip install python-binance"
    ]
  }
}

# Output the public IP address to a file
resource "null_resource" "export_ip_to_file" {
  provisioner "local-exec" {
    command = "echo ${azurerm_linux_virtual_machine.vm.public_ip_address} > ip.txt"
  }
}