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
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
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

resource "azurerm_resource_group" "rg6" {
  name     = "RG6"
  location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "VNET1"
  location            = azurerm_resource_group.rg6.location
  resource_group_name = azurerm_resource_group.rg6.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    Department = "D1"
  }
}

# Policies
resource "azurerm_resource_group_policy_assignment" "default" {
  name = "applytaganddefaultvaule"
  # Policy: Add a Tag to Resources
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4f9dc7db-30c1-420c-b61a-e1d640128d26"
  resource_group_id    = azurerm_resource_group.rg6.id
  enforce              = true
  location             = azurerm_resource_group.rg6.location

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
    {
      "TagName": { 
        "value": "Label"
      },
      "TagValue": { 
        "value": "Value1"
      }
    }
  PARAMETERS
}
