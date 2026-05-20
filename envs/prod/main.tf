########################################
# Terraform + Backend
########################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-nunovus-terraform-state"
    storage_account_name = "tfstatenunovusprodstr"
    container_name       = "tfstate"
    key                  = "nunovus-prod-avd.tfstate"
  }
}

########################################
# Azure Provider
########################################

provider "azurerm" {
  features {}
}

########################################
# Local Values
########################################

locals {

  ########################################
  # Customer + Environment
  ########################################

  client_name = "landwise"
  environment = "prod"

  ########################################
  # Azure Region
  ########################################

  location      = "East US"
  location_code = "eus"

  ########################################
  # Naming Prefix
  ########################################

  prefix = "${local.client_name}-${local.environment}-${local.location_code}"

  ########################################
  # Common Tags
  ########################################

  tags = {
    client      = local.client_name
    environment = local.environment
    managed_by  = "terraform"
  }
}

########################################
# Resource Groups
########################################

resource "azurerm_resource_group" "network" {
  name     = "${local.prefix}-rg-network"
  location = local.location

  tags = local.tags
}

resource "azurerm_resource_group" "avd" {
  name     = "${local.prefix}-rg-avd"
  location = local.location

  tags = local.tags
}

########################################
# Network Module
########################################

module "network" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//network"

  resource_group_name = azurerm_resource_group.network.name
  location            = local.location

  ########################################
  # VNET
  ########################################

  vnet_name = "${local.prefix}-vnet"
  vnet_cidr = "10.0.0.0/16"

  ########################################
  # Subnets
  ########################################

  subnets = {

    # AVD Session Hosts
    "${local.prefix}-snet-avd" = "10.0.1.0/24"

    # Domain Controllers
    "${local.prefix}-snet-ad" = "10.0.2.0/24"

    # Bastion
    "${local.prefix}-snet-bastion" = "10.0.3.0/27"

    # VPN Gateway
    "GatewaySubnet" = "10.0.4.0/27"
  }

  tags = local.tags
}

########################################
# Active Directory Domain Services
########################################

module "adds" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//adds"

  ########################################
  # General
  ########################################

  resource_group_name = azurerm_resource_group.avd.name
  location            = local.location

  ########################################
  # Networking
  ########################################

  subnet_id = module.network.subnet_ids["${local.prefix}-snet-ad"]

  private_ip_address = "10.0.2.4"

  ########################################
  # VM Configuration
  ########################################

  vm_name       = "${local.prefix}-dc-01"
  computer_name = "dc01"

  vm_size = "Standard_B2ms"

  ########################################
  # OS Disk
  ########################################

  os_disk_type = "StandardSSD_LRS"

  ########################################
  # Credentials
  ########################################

  admin_username = var.admin_username
  admin_password = var.admin_password

  ########################################
  # Active Directory
  ########################################

  domain_name        = "landwise.com"
  safe_mode_password = var.admin_password

  ########################################
  # Tags
  ########################################

  tags = local.tags
}

########################################
# Configure VNet DNS
########################################

resource "azurerm_virtual_network_dns_servers" "dns" {

  virtual_network_id = module.network.vnet_id

  dns_servers = [
    module.adds.private_ip_address,
    "8.8.8.8"
  ]
}

########################################
# AVD Module
########################################

module "avd" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//avd"

  ########################################
  # Networking
  ########################################

  subnet_id = module.network.subnet_ids["${local.prefix}-snet-avd"]

  ########################################
  # AVD Naming
  ########################################

  host_pool_name = "${local.prefix}-avd-hp"
  app_group_name = "${local.prefix}-avd-dag"
  workspace_name = "${local.prefix}-avd-ws"

  ########################################
  # Resource Group + Region
  ########################################

  resource_group_name = azurerm_resource_group.avd.name
  location            = local.location

  ########################################
  # Personal Host Pool
  ########################################

  host_pool_type     = "Personal"

  load_balancer_type = "Persistent"

  max_sessions       = 1

  ########################################
  # Session Hosts
  ########################################

  vm_name_prefix = "${local.prefix}-avd-vm"

  session_host_count = 7

  vm_size = "Standard_D2alds_v6"

  ########################################
  # Windows Image
  ########################################

  image_sku = "win11-22h2-ent"

  ########################################
  # OS Disk
  ########################################

  os_disk_type = "Premium_LRS"

  ########################################
  # Credentials
  ########################################

  admin_username = var.admin_username
  admin_password = var.admin_password

  ########################################
  # Domain Join
  ########################################

  domain_name = "landwise.com"

  domain_user = "azureuser"

  domain_password = var.admin_password

  ########################################
  # Tags
  ########################################

  tags = local.tags
}
