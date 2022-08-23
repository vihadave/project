variable "ado_org_service_url" {
  type        = string
  description = "Org service url for Azure DevOps"
  default = "https://dev.azure.com/vihadave/"
}

variable "ado_github_repo" {
  type        = string
  description = "Name of the repository in the format <GitHub Org>/<RepoName>"
  default     = "vihadave/project"
}

variable "ado_pipeline_yaml_path_1" {
  type        = string
  description = "Path to the yaml for the first pipeline"
  default     = "project/resources/Resource_Creation_pipeline.yml"
}

variable "ado_github_pat" {
  type        = string
  description = "Personal authentication token for GitHub repo"
  default = "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"
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "automated"
}

variable "az_location" {
  type    = string
  default = "Central US"
}

variable "az_container_name" {
  type        = string
  description = "Name of container on storage account for Terraform state"
  default     = "tfstatedata"
}

variable "az_state_key" {
  type        = string
  description = "Name of key in storage account for Terraform state"
  default     = "terraform.tfstate"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

locals {
  ado_project_name        = "${var.prefix}-project-${random_integer.suffix.result}"
  ado_project_description = "Project for ${var.prefix}"
  ado_project_visibility  = "private"
  ado_pipeline_name_1     = "${var.prefix}-pipeline-1"

  az_resource_group_name  = "${var.prefix}${random_integer.suffix.result}"
  az_storage_account_name = "${lower(var.prefix)}${random_integer.suffix.result}"
  az_key_vault_name = "${var.prefix}${random_integer.suffix.result}"

  pipeline_variables = {
    storageaccount = "${lower(var.prefix)}${random_integer.suffix.result}"
    container-name = "tfstatedata"
    key = "terraform.tfstate"
    sas-token = data.azurerm_storage_account_sas.state.sas
    az-client-id = azuread_application.resource_creation.application_id
    az-client-secret = random_password.resource_creation.result
    az-subscription = "94a5c35a-b41a-4ffa-a37a-7d5df5344262"
    az-tenant = "18c3b4f7-e526-4f98-939a-19118361cac0"
  }

  azad_service_connection_sp_name = "${var.prefix}-service-connection-${random_integer.suffix.result}"
  azad_resource_creation_sp_name = "${var.prefix}-resource-creation-${random_integer.suffix.result}"
}
