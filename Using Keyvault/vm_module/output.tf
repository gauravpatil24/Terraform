output "resource_group_name" {
  value = azurerm_resource_group.myterraformgroup.name
}

output "vm_ip" {
  value = azurerm_windows_virtual_machine.myterraformvm.public_ip_address
}

output "virtual_machine_name" {
  value = azurerm_windows_virtual_machine.myterraformvm.name
}

output "sku" {
  value= azurerm_windows_virtual_machine.myterraformvm.source_image_reference[0].sku
}

output "keyvault_name" {
  value = data.azurerm_key_vault.local.name
}

output "keyvault_resource_group" {
  value = data.azurerm_key_vault.local.resource_group_name
}

output "keyvault_id" {
  value = data.azurerm_key_vault.local.id
}