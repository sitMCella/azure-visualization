terraform {
  required_version = "~> 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.16.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "<subscription_id>"
  features {
  }
}
