terraform {
  required_version = ">= 1.6.0, <= 2.0.0"
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.64.0"
    }
    azapi = {
      version = "1.4.0"
      source  = "Azure/azapi"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.48.0"
    }
  }
}

provider "azurerm" {
  use_oidc = true
  features {
    key_vault {
      purge_soft_delete_on_destroy          = true
      purge_soft_deleted_secrets_on_destroy = true
    }
  }
}
