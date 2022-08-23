resource "azuread_application" "service_connection" {
  display_name               = local.azad_service_connection_sp_name
}

resource "azuread_service_principal" "service_connection" {
  application_id               = azuread_application.service_connection.application_id
}

resource "random_password" "service_connection" {
  length = 16
}

resource "azuread_service_principal_password" "service_connection" {
  service_principal_id = azuread_service_principal.service_connection.object_id
  value = random_password.service_connection.result
}

# Create SP for creation of Azure resources in selected subscription.
# These credentials will be written to the Key Vault and retrieved during pipeline run

resource "azuread_application" "resource_creation" {
  display_name               = local.azad_resource_creation_sp_name
}

resource "azuread_service_principal" "resource_creation" {
  application_id               = azuread_application.resource_creation.application_id
}

resource "random_password" "resource_creation" {
  length = 16
}

resource "azuread_service_principal_password" "resource_creation" {
  service_principal_id = azuread_service_principal.resource_creation.object_id
  value = random_password.resource_creation.result
}

resource "azurerm_role_assignment" "resource_creation" {
  scope = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id = azuread_service_principal.resource_creation.object_id
}
