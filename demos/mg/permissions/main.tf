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

resource "azurerm_policy_definition" "notallow_vnet_root" {
  name                = "only-deploy-in-westeurope"
  policy_type         = "BuiltIn"
  mode                = "All"
  management_group_id = data.azurerm_management_group.root.id


  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "equals": "westeurope"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
}


# resource "azurerm_management_group_policy_assignment" "notallow_vnet_root" {
#   name                 = "NotAllowVnetsOnRoot"
#   policy_definition_id = azurerm_policy_definition.notallow_vnet_root.id
#   management_group_id  = data.azurerm_management_group.root.id
# }
