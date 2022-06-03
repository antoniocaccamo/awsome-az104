terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8.0"
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

variable "tenant_root_group" {
  sensitive = true
}

variable "subscription1" {
  sensitive = true
}

variable "subscription2" {
  sensitive = true
}

variable "location" {
  default     = "brazilsouth"
  sensitive   = false
  description = "Use .auto.tfvars to set a location near you"
}


### Management Groups ###

data "azurerm_subscription" "sub1" {
  subscription_id = var.subscription1
}

data "azurerm_subscription" "sub2" {
  subscription_id = var.subscription2
}

data "azurerm_management_group" "root" {
  name = var.tenant_root_group
}

# Management Groups

resource "azurerm_management_group" "mg11" {
  display_name               = "ManagementGroup11"
  parent_management_group_id = data.azurerm_management_group.root.id
}

resource "azurerm_management_group" "mg12" {
  display_name               = "ManagementGroup12"
  parent_management_group_id = data.azurerm_management_group.root.id
}

resource "azurerm_management_group" "mg21" {
  display_name               = "ManagementGroup21"
  parent_management_group_id = azurerm_management_group.mg11.id
}

# Subscriptions Associations

resource "azurerm_management_group_subscription_association" "sub1" {
  management_group_id = azurerm_management_group.mg21.id
  subscription_id     = data.azurerm_subscription.sub1.id
}

resource "azurerm_management_group_subscription_association" "sub2" {
  management_group_id = azurerm_management_group.mg12.id
  subscription_id     = data.azurerm_subscription.sub2.id
}

# Policies

resource "azurerm_management_group_policy_assignment" "notallowed_resourcetypes_root" {
  name                 = "NotAllowedRoot"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  management_group_id  = data.azurerm_management_group.root.id
  enforce              = true
  parameters           = <<PARAMETERS
    {
      "listOfResourceTypesNotAllowed": { 
        "value": [ "Microsoft.Network/virtualNetworks" ]
      }
    }
  PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "allowed_resourcetypes_group12" {
  name                 = "AllowedGroup12"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c"
  management_group_id  = azurerm_management_group.mg12.id
  enforce              = true
  parameters           = <<PARAMETERS
    {
      "listOfResourceTypesAllowed": { 
        "value": [ "Microsoft.Network/virtualNetworks" ]
      }
    }
  PARAMETERS
}
