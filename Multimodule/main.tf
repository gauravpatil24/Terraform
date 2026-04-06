#Resource Group Creation
module "my_module_resgrp" {
  source   = "./module_rg"
  rgname   = "myResourceGroup"
  location = "Central India"
}
##############################################################################################

#Storage Account Creation
module "my_module_storage" {
  source         = "./module_storage"
  storageaccname = "storageaccount"
  rgname         = module.my_module_resgrp.rgname_output
  location       = module.my_module_resgrp.rglocation_output
}

#azurerm_management_lock
#Manages a Management Lock which is scoped to a Subscription, Resource Group or Resource.
resource "azurerm_management_lock" "storage-lock" {
  name       = "storage-lock"
  scope      = module.my_module_storage.storage-id
  lock_level = "CanNotDelete"
  notes      = "This lock is applied to storage account to prevent accidental deletion."
}
##############################################################################################

#Virtual Network Creation
module "my_module_virtualnetwork" {
  source      = "./module_network"
  resgrp_name = module.my_module_resgrp.rgname_output
  location    = module.my_module_resgrp.rglocation_output
  vnet_name   = "demo-vnet001"
  app_subnet  = "app-subnet"
  db_subnet   = "db-subnet"
}

#Network Interface Card Creation
module "my_module_niccard" {
  source       = "./module_interfacecard"
  resgrp_name  = module.my_module_resgrp.rgname_output
  location     = module.my_module_resgrp.rglocation_output
  nic_name     = "demo-nic001"
  app_subnetid = module.my_module_virtualnetwork.app_subnetid_output
  pubip_id     = module.my_module_publicip.pubip_output
}

##############################################################################################

#Public IP Creation
module "my_module_publicip" {
  source      = "./module_publicip"
  resgrp_name = module.my_module_resgrp.rgname_output
  location    = module.my_module_resgrp.rglocation_output
  pubip_name  = "demo-pubip001"
}

#azurerm_management_lock
#Manages a Management Lock which is scoped to a Subscription, Resource Group or Resource.
resource "azurerm_management_lock" "pubip-lock" {
  name       = "pubip-lock"
  scope      = module.my_module_publicip.pubip_output
  lock_level = "CanNotDelete"
  notes      = "This lock is applied to public IP to prevent accidental deletion."
}
##############################################################################################

#Network Security Group Creation
module "my_module_nsg" {
  source       = "./module_nsg"
  resgrp_name  = module.my_module_resgrp.rgname_output
  location     = module.my_module_resgrp.rglocation_output
  app_subnetid = module.my_module_virtualnetwork.app_subnetid_output
  nsg_name     = "demo-nsg001"
}



