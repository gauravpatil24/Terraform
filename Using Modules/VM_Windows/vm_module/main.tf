resource "azurerm_resource_group" "myterraformgroup" {
  name = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "myterraformnetwork" {
  name = var.virtual_network_name
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_subnet" "myterraformsubnet" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "myterraformpublicip" {
  name = var.public_ip_name
  location = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method = "Static"
}


resource "azurerm_network_security_group" "myterraformnsg" {
  name = "myNetworkSecurityGroup"
  location = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name = "test123"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    #destination_port_ranges = ["22","80","443","32323"]
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface" "myterraformnic" {
  name = "myNIC"
  location = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name = "myNICconfiguration"
    subnet_id = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.myterraformpublicip.id
  }
}


resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


resource "azurerm_windows_virtual_machine" "myterraformvm" {
  name = var.virtual_machine_name
  location = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size = "Standard_F2"
  admin_username = "vmadmin"
  admin_password = "Welcome@2025"


  os_disk {
    name = "myOSDisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS" 
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }

  
}