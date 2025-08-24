output "instance_ip_address" {
  value = azurerm_windows_virtual_machine.local.public_ip_address
}

output "instance_name" {
  value = azurerm_windows_virtual_machine.local.name
}