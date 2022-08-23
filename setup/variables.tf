variable "azad_service_connection_sp_name" {
  type = string
  description = "service connection name"
  #value =  
}

variable "azad_resource_creation_sp_name" {
  type = string
  description = "name of service principal for creation of resources"
  #value = "project/resources/resource_creation_pipeline.yml"
}

variable "ado_org_service_url" {
  type = string
  description = "personal access token"
  #value = https://dev.azure.com/vihadave/
}

variable "ado_project_name" {
  type = string
  description = "project name in azure devops"
  #value =
}

variable "ado_project_description" {
  type = string
  description = "azure devops project description"
  #value = 
}

variable "ado_project_visibility" {
  type = string
  description = "azure devops project visibility"
  #value = 
}

variable "az-client-id" {
  type = string
  description = "application id of azure ad application"
  value = azuread_application.resource_creation.application_id
}

variable "az-client-secret" {
  type = string
  description = "password"
  value = random_password.resource_creation.result
}

variable "az-subscription" {
  type = string
  description = "subscription id"
  value = data.azurerm_client_config.current.subscription_id
}

variable "az-tenant" {
  type = string
  description = "tenant id"
  value = data.azurerm_client_config.current.tenant_id
}

variable "azad_service_connection_sp_name" {
  type = string
  description = "service connection sp name"
  value = "${var.prefix}-service-connection-${random_integer.suffix.result}"
}

variable "azad_resource_creation_sp_name" {
  type = string
  description = "resource creation sp name"
  value = "${var.prefix}-resource-creation-${random_integer.suffix.result}"
}

variable "az_location" {
  type = string
  description = "location"
  #value = "Central US"
}

variable "az_container_name" {
  type = string
  description = "backend container name"
  #value = ""
}

variable "az_state_key" {
  type = string
  description = "name of key in backend st"
  #value = "terraform.tfstate"
}

variable "az_client_id" {
  type = string
  description = "client id with permissions for creation of resources in azure, use env variables"
}

variable "az_client_secret" {
  type = string
  description = "client secret with permissions for creation of resources in azure, use env variables"
}

variable "az_subscription" {
  type = string
  description = "client id subscription, use env variables"
}

variable "az_tenant" {
  type = string
  description = "client id azure tenant, use env variables"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}
