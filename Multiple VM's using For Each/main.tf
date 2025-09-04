resource "azurerm_resource_group" "local" {
  location = "Central India"
  name     = "resgrp"
}

# data "azurerm_resource_group" "local" {
#   name = "resgrp"
# }

resource "azurerm_virtual_network" "local" {
  name                = "myvnet"
  location            = azurerm_resource_group.local.location
  resource_group_name = azurerm_resource_group.local.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "local" {
  name                 = "mysubnet"
  virtual_network_name = azurerm_virtual_network.local.name
  resource_group_name  = azurerm_resource_group.local.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "local" {
  name                = each.value.ip_name
  resource_group_name = azurerm_resource_group.local.name
  location            = azurerm_resource_group.local.location
  allocation_method   = "Static"
  for_each            = var.vm
}


resource "azurerm_network_interface" "local" {
  name                = each.value.nic_name
  location            = azurerm_resource_group.local.location
  resource_group_name = azurerm_resource_group.local.name
  for_each            = var.vm
  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.local.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.local[each.key].id
  }
}

resource "azurerm_network_security_group" "local" {
  name                = "mynsg"
  location            = azurerm_resource_group.local.location
  resource_group_name = azurerm_resource_group.local.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "32323"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  #   tags = { environment="Production" }
}


resource "azurerm_network_interface_security_group_association" "local" {
  network_interface_id      = azurerm_network_interface.local[each.key].id
  network_security_group_id = azurerm_network_security_group.local.id
  for_each                  = var.vm
}


resource "azurerm_linux_virtual_machine" "local" {
  name                            = each.value.vm_name
  location                        = azurerm_resource_group.local.location
  resource_group_name             = azurerm_resource_group.local.name
  size                            = "Standard_A2_V2"
  computer_name                   = "hostname-${each.value.vm_name}"
  admin_username                  = "vmadmin"
  admin_password                  = "Welcome@2025"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.local[each.key].id]
  for_each                        = var.vm
  os_disk {
    name                 = "myosdisc-${each.value.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS  "
    version   = "latest"
  }

  connection {
    host     = self.public_ip_address
    user     = "vmadmin"
    password = "Welcome@2025"
    type     = "ssh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install curl",
      "curl -LO https://storage.googleapis.com/kubern...`curl -s https://storage.googleapis.com/kubern...`/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin/kubectl",
      "sudo apt-get install docker.io -y",
      "sudo gpasswd -a $USER docker",
      "wget https://storage.googleapis.com/miniku...",
      "chmod +x minikube-linux-amd64",
      "sudo mv minikube-linux-amd64 /usr/local/bin/minikube",
      "sudo apt-get install conntrack -y",
      "sudo minikube start --vm-driver=none",
      "sudo chown -R $USER $HOME/.kube $HOME/.minikube"
    ]
  }
}