resource "azurerm_resource_group" "local" {
  location = "Central india"
  name     = "resgrp"
}

resource "azurerm_virtual_network" "local" {
  name                = "myvnet"
  location            = azurerm_resource_group.local.location
  resource_group_name = azurerm_resource_group.local.id
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "local" {
  name                 = "mysubnet"
  virtual_network_name = azurerm_virtual_network.local.name
  resource_group_name  = azurerm_resource_group.local.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "local" {
  name                = "mynic"
  location            = azurerm_resource_group.local.location
  resource_group_name = azurerm_resource_group.local.name
  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.local.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.local.id
  }
}

resource "azurerm_network_security_group" "local" {
  name                = "mynsg"
  location            = azurerm_resource_group.local.location
  resource_group_name = azurerm_resource_group.local.name
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  #   tags = { environment="Production" }
}

resource "azurerm_public_ip" "local" {
  name                = "mypublicip"
  resource_group_name = azurerm_resource_group.local.name
  location            = azurerm_resource_group.local.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface_security_group_association" "local" {
  network_interface_id      = azurerm_network_interface.local.id
  network_security_group_id = azurerm_network_security_group.local.id
}


resource "azurerm_windows_virtual_machine" "local" {
  name                  = "myvm"
  location              = azurerm_resource_group.local.location
  resource_group_name   = azurerm_resource_group.local.name
  size                  = "Standard_F2"
  admin_username        = "vmadmin"
  admin_password        = "Welcome@2025"
  network_interface_ids = [azurerm_network_interface.local.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}