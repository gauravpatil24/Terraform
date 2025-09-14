output "resource_group_name" {
  value = azurerm_resource_group.myterraformgroup.name
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.myterraformvm.public_ip_address
}