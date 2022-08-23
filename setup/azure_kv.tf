data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Create a Key Vault
resource "azurerm_key_vault" "setup" {
  name = local.az_key_vault_name
  location = "West Central US"
  resource_group_name = data.azurerm_resource_group.rg.name
  tenant_id = "18c3b4f7-e526-4f98-939a-19118361cac0"

  sku_name = "standard"
}

# Set access policies
# Grant yourself full access (probably could be restricted to just secret_permissions)
resource "azurerm_key_vault_access_policy" "you" {
  key_vault_id = azurerm_key_vault.setup.id

  tenant_id = "18c3b4f7-e526-4f98-939a-19118361cac0"
  object_id = "ab142348-d7e9-4440-b227-7b6983e9af69"

  key_permissions = [
    "get", "list", "update", "create", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify", "sign",
  ]

  secret_permissions = [
    "get", "list", "set", "delete", "purge", "recover", "backup"
  ]

  certificate_permissions = [
    "get", "list", "create", "import", "delete", "update",
  ]
}

# Grant the pipeline SP access to [get,list] secrets from the KV
resource "azurerm_key_vault_access_policy" "pipeline" {
  key_vault_id = azurerm_key_vault.setup.id

  tenant_id = "18c3b4f7-e526-4f98-939a-19118361cac0"
  object_id = azuread_service_principal.service_connection.object_id

  secret_permissions = [
    "get", "list",
  ]

}

# Populate with secrets to be used by the pipeline
resource "azurerm_key_vault_secret" "pipeline" {
  depends_on = [
    azurerm_key_vault_access_policy.you
  ]
  for_each = local.pipeline_variables
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.setup.id
}
