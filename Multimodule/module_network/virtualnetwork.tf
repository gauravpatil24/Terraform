resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location = var.location
  resource_group_name = var.resgrp_name
  address_space = ["10.0.0.0/16"]

  depends_on = [ var.resgrp_name ]
}


resource "azurerm_subnet" "app-sub" {
  name                 = var.app_subnet
  resource_group_name  = var.resgrp_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.1.0/24"] 

  depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_subnet" "db-sub" {
  name                 = var.db_subnet
  resource_group_name  = var.resgrp_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.2.0/24"]

   depends_on = [ azurerm_virtual_network.vnet ]
}