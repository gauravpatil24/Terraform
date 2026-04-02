resource "azurerm_network_interface" "nicdetails" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resgrp_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.app_subnetid
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.pubip_id
  }

   depends_on = [ var.app_subnetid ]
}