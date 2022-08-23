terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.17.0" 

    }

    azuread = {
      source = "hashicorp/azuread"
      version = "~> 1.0"
    }

  }
  backend "remote" {
    organization = "ned-in-the-cloud"

    workspaces {
      name = "terraform-tuesday-ado-setup"
    }
  }
}

provider "azurerm" {
  features {}
  
  subscription_id = "94a5c35a-b41a-4ffa-a37a-7d5df5344262"
  tenant_id = "18c3b4f7-e526-4f98-939a-19118361cac0"  
}
