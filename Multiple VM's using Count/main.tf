resource "azurerm_resource_group" "local" {
  location = var.resource_group_location
  name     = var.resource_group_name
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
  name                = "mynic-${count.index + 1}"
  location            = azurerm_resource_group.local.location
  resource_group_name = azurerm_resource_group.local.name
  count = var.numberofVM
  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.local.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.local[count.index].id
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
  name                = "mypublicip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.local.name
  location            = azurerm_resource_group.local.location
  allocation_method   = "Static"
  count = var.numberofVM
}

resource "azurerm_network_interface_security_group_association" "local" {
  network_interface_id      = azurerm_network_interface.local[count.index].id
  network_security_group_id = azurerm_network_security_group.local.id
  count = var.numberofVM
}


resource "azurerm_windows_virtual_machine" "local" {
  name                  = "myvm-${count.index + 1}"
  location              = azurerm_resource_group.local.location
  resource_group_name   = azurerm_resource_group.local.name
  size                  = "Standard_F2"
  computer_name = "hostname-${count.index + 1}"
  admin_username        = "vmadmin"
  admin_password        = "Welcome@2025"
  network_interface_ids = [azurerm_network_interface.local[count.index].id]
  count = var.numberofVM
  os_disk {
    name = "myosdisc-${count.index + 1}"
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