# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  #required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}


# Confgiure the resource group for the project
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}rg"
  location = var.location
  tags = {
    Environment = "${var.prefix}"
  }
}

# Prefix name for all resources in resource group
variable "prefix" {
  type = string
}

# Default location for all resources
variable "location" {
  type = string
}

# Number of virtuall machines in the HA zone
variable "instance_count" {
  type = number
}

# Default VM size
variable "vm_size" {
  type = string
}

# Default VM user
variable "admin-user" {
  type = string
}
variable "admin-password" {
  type = string
}

module "vms" {
  source         = "./modules/vms"
  prefix         = var.prefix
  rg-name        = local.rg-name
  location       = var.location
  instance_count = var.instance_count
  vm_size        = var.vm_size
  DataTierNSG_id = azurerm_network_security_group.DataTierNSG.id
  WebTierNSG_id  = azurerm_network_security_group.WebTierNSG.id
  admin-user     = var.admin-user
  admin-password = var.admin-password
}

locals {
  location = var.location
  prefix   = var.prefix
  rg-name  = azurerm_resource_group.rg.name
}

