terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
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
  description = "Change this to a location near you"
}

variable "storage_account_name" {
  default     = "stawsomeaz104cloudshell"
  sensitive   = false
  description = "Change in case the default is already taken"
}

locals {
  app_affix     = "awsomeaz104-aks-grantaccess-demo"
  password      = "DemoPassword!123"
  aks_namespace = "default"
}

### Azure Active Directory ###

data "azuread_domains" "aad_domains" {
  only_default = true
}

resource "azuread_user" "aks_user" {
  user_principal_name = "aksuser@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "AKS User"
  password            = local.password
}


### Resources ###

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.app_affix}"
  location = var.location
}

resource "azurerm_role_assignment" "rg_read" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.aks_user.object_id
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "aks-${local.app_affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "awsome-az104-demo"
  node_resource_group = "k8s-aks-${local.app_affix}"

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name       = local.aks_namespace
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aks_admin" {
  scope                = "${azurerm_kubernetes_cluster.default.id}/namespaces/${local.aks_namespace}"
  role_definition_name = "Azure Kubernetes Service RBAC Admin"
  principal_id         = azuread_user.aks_user.object_id
}

resource "azurerm_storage_account" "cloud_shell" {
  name                     = var.storage_account_name
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "cloud_shell" {
  name                 = "cloud-shell"
  storage_account_name = azurerm_storage_account.cloud_shell.name
  quota                = 1
}

resource "azurerm_role_assignment" "shell" {
  scope                = azurerm_storage_account.cloud_shell.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azuread_user.aks_user.object_id
}


### Outputs

output "aks_user" {
  value     = azuread_user.aks_user.user_principal_name
  sensitive = false
}

output "aks_name" {
  value     = azurerm_kubernetes_cluster.default.name
  sensitive = false
}

output "rg_name" {
  value     = azurerm_resource_group.default.name
  sensitive = false
}

output "az_get_credentials" {
  value     = "az aks get-credentials -n ${azurerm_kubernetes_cluster.default.name} -g ${azurerm_resource_group.default.name}"
  sensitive = false
}
