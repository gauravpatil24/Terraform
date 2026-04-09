resource "azurerm_resource_group" "sql_resgrp" {
  name     = "sql-resgrp"
  location = "central india" 
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = "demosql-server-001"
  resource_group_name          = azurerm_resource_group.sql_resgrp.name
  location                     = azurerm_resource_group.sql_resgrp.location
  version                      = "12.0"
  administrator_login          = "admin"
  administrator_login_password = azurerm_key_vault_secret.pass.value

  depends_on = [ azurerm_resource_group.sql_resgrp ]
}

resource "azurerm_mssql_database" "sqldb" {
  name                = "demodb-001"
  server_id           = azurerm_mssql_server.mssql_server.id
  sku_name            = "S0"

  depends_on = [ azurerm_mssql_server.mssql_server, azurerm_resource_group.sql_resgrp ]
}



data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "keyault-demo-001"
  location                    = azurerm_resource_group.sql_resgrp.location
  resource_group_name         = azurerm_resource_group.sql_resgrp.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7

access_policy  {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get","list","set"
    ]
  }
    depends_on = [ azurerm_resource_group.sql_resgrp ]
}


resource "azurerm_key_vault_secret" "pass" {
  name = "password"
  value = "Welcome@2026"
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [ azurerm_key_vault.keyvault ]
}


  

