terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.9.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

### Variables ###

variable "location" {
  default     = "brazilsouth"
  sensitive   = false
  description = "Use .auto.tfvars to set a location near you"
}

variable "subscription_name_prefix" {
  default   = "Pay-As-You-Go"
  sensitive = false
}

### Resources ###

# Data Source
data "azurerm_subscription" "current" {
}

# Resource Group

resource "azurerm_resource_group" "rg1" {
  name     = "ContosoRG1"
  location = var.location
}

resource "azurerm_resource_group" "rg2" {
  name     = "ContosoRG2"
  location = var.location
}

# Policies
resource "azurerm_subscription_policy_assignment" "default" {
  name                 = "Not Allowed Resource Types"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  subscription_id      = data.azurerm_subscription.current.id
  enforce              = true

  not_scopes = [azurerm_resource_group.rg1.id]

  parameters = <<PARAMETERS
    {
      "listOfResourceTypesNotAllowed": { 
        "value": [ "Microsoft.Sql/servers" ]
      }
    }
  PARAMETERS
}
