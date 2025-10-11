data "azurerm_key_vault" "local" {
  name = "keyvaultformodule"
  resource_group_name = "resgrpkeyvault"
}

data "azurerm_key_vault_secret" "localusername" {
  name = "username"
  key_vault_id = data.azurerm_key_vault.name.id
}

data "azurerm_key_vault_secret" "localpassword" {
  name = "password"
  key_vault_id = data.azurerm_key_vault.local.id
}