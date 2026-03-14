
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_group
  name     = each.value.resource_group_name
  location = each.value.location
}

resource "azurerm_storage_account" "storageaccount" {
  for_each            = var.resource_group
  name                = each.value.stoage_account_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  account_tier        = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.rg ]
   
}

resource "azurerm_storage_container" "container" {
  for_each = var.resource_group
  name                 = each.value.container_name
  storage_account_id = azurerm_storage_account.storageaccount[each.key].id
  container_access_type = "blob"
  depends_on = [ azurerm_storage_account.storageaccount ]
}

resource "azurerm_storage_blob" "blob" {
  for_each = var.resource_group
  name                 = "${each.value.container_name}.txt"
  storage_account_name = each.value.stoage_account_name
  storage_container_name = each.value.container_name
  type                 = "Block"
  source               = each.value.blob_name
  depends_on = [ azurerm_storage_container.container ]  
  
}