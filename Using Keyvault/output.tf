output "ip_value" {
  value = module.vm.vm_ip
}

output "virtual_machine_name" {
  value = module.vm.virtual_machine_name
}

output "resource_group_name" {
  value = module.vm.resource_group_name
}

output "sku" {
  value = module.vm.sku
}

output "keyvault_id" {
  value = module.vm.keyvault_id
}

output "keyvault_name" {
  value = module.vm.keyvault_name
}

output "keyvault_resource_group" {
  value = module.vm.keyvault_resource_group
}