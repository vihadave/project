provider "azuredevops" {
  org_service_url = var.ado_org_service_url
  # Authentication through PAT defined with AZDO_PERSONAL_ACCESS_TOKEN 
}

resource "azuredevops_project" "project" {
  name               = local.ado_project_name
  description        = local.ado_project_description
  visibility         = local.ado_project_visibility
  version_control    = "Git"   # This will always be Git for me
  work_item_template = "Agile" # Not sure if this matters, check back later

  features = {
    # Only enable pipelines for now
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
  }
}


resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "project"

  auth_personal {
    personal_access_token = var.ado_github_pat
  }
}

resource "azuredevops_resource_authorization" "auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  authorized  = true
}

resource "azuredevops_variable_group" "variablegroup" {
  project_id   = azuredevops_project.project.id
  name         = "variable-group"
  description  = "Variable group for pipelines"
  allow_access = true

  variable {
    name  = "service_name"
    value = "key_vault"
  }

  variable {
    name = "key_vault_name"
    value = local.az_key_vault_name
  }

}

resource "azuredevops_build_definition" "pipeline_1" {

  depends_on = [azuredevops_resource_authorization.auth]
  project_id = azuredevops_project.project.id
  name       = local.ado_pipeline_name_1

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.ado_github_repo
    branch_name           = "main"
    yml_path              = var.ado_pipeline_yaml_path_1
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  }

}

# Key Vault setup
## There needs to be a service connection to an Azure sub with the key vault
## https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm

resource "azuredevops_serviceendpoint_azurerm" "key_vault" {
  project_id = azuredevops_project.project.id
  service_endpoint_name = "key_vault"
  description = "Azure Service Endpoint for Key Vault Access"

  credentials {
    serviceprincipalid = azuread_application.service_connection.application_id
    serviceprincipalkey = random_password.service_connection.result
  }

  azurerm_spn_tenantid = "18c3b4f7-e526-4f98-939a-19118361cac0"
  azurerm_subscription_id = "94a5c35a-b41a-4ffa-a37a-7d5df5344262"
  azurerm_subscription_name = "Anblicks - IP"
}

resource "azuredevops_resource_authorization" "kv_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.key_vault.id
  authorized  = true
}

