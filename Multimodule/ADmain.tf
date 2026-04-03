#Resource Group-2 creation
resource "azurerm_resource_group" "rg2" {
  name     = "AD-ResourceGroup2"
  location = "Central India"
}


resource "azuread_user" "user1" {
  user_principal_name = "gpatil@gauravgmpgmail.onmicrosoft.com"
  display_name        = "Gaurav Patil"
  mail_nickname       = "gpatil"
  password            = "Welcome@2026"
}

resource "azurerm_role_assignment" "Reader" {
  scope                = azurerm_resource_group.rg2.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.user1.object_id

  depends_on = [azuread_user.user1]
}


data "azurerm_subscription" "primary" {}

resource "azurerm_role_definition" "custom-role-definition" {
  name        = "custom-vm-role"
  scope       = data.azurerm_subscription.primary.id
  description = "Custom role with permissions to manage virtual machines."
  permissions {
    actions = [
      "Microsoft.Compute/*/read",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/restart/action",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}

resource "azurerm_role_assignment" "custom-vm-assignment" {
  scope                = azurerm_resource_group.rg2.id
  role_definition_name = azurerm_role_definition.custom-role-definition.name
  principal_id         = azuread_user.user1.object_id

  depends_on = [azuread_user.user1, azurerm_resource_group.rg2, azurerm_role_definition.custom-role-definition]
}