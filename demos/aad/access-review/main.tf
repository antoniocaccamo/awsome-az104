terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

### Variables ###

locals {
  password = "DemoPassword!123"
}

### Azure Active Directory ###

data "azuread_client_config" "current" {}

data "azuread_domains" "aad_domains" {
  only_default = true
}

# Users

resource "azuread_user" "user1" {
  user_principal_name = "user1@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "User1"
  password            = local.password
}

resource "azuread_user" "user3" {
  user_principal_name = "user3@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "User3"
  password            = local.password
}

resource "azuread_user" "userA" {
  user_principal_name = "userA@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "UserA"
  password            = local.password
}

# Groups

resource "azuread_group" "group1" {
  display_name     = "Group1"
  security_enabled = true

  owners = [
    azuread_user.user3.object_id,
  ]

  members = [
    azuread_user.user1.object_id,
    azuread_group.group2.id
  ]
}

resource "azuread_group" "group2" {
  display_name     = "Group1"
  security_enabled = true

  members = [
    azuread_user.userA.object_id
  ]
}

output "group1_id" {
  value = azuread_group.group1.object_id
}

output "group2_id" {
  value = azuread_group.group2.object_id
}
