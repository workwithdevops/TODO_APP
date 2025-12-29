
# Provider configuration
#==============================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "f0c98d1e-0f24-4ed7-b54d-a6bbfb322acd"
}

# # Create a resource group
# #==============================================================================

resource "azurerm_resource_group" "rg" {
  name     = "rg-test"
  location = "central india"
}

# # Data sources to fetch existing subnets
# #==============================================================================

# data "azurerm_subnet" "f_subnet" {
#   name                 = "frontend"
#   virtual_network_name = "vnet-test"
#   resource_group_name  = "rg-test"
# }

# data "azurerm_subnet" "b_subnet" {
#   name                 = "backend"
#   virtual_network_name = "vnet-test"
#   resource_group_name  = "rg-test"
# }

# # Get current client configuration
# #==============================================================================

data "azurerm_client_config" "current" {}

# # Create a virtual network with subnets
# #==============================================================================

# resource "azurerm_virtual_network" "vnet" {
#   name                = "vnet-test"
#   location            = "central india"
#   resource_group_name = azurerm_resource_group.rg.name
#   address_space       = ["10.0.0.0/16"]

#   subnet {
#     name             = "frontend"
#     address_prefixes = ["10.0.1.0/24"]
#   }

#   subnet {
#     name             = "backend"
#     address_prefixes = ["10.0.2.0/24"]
#   }
# }

# # Create frontend  public IP
# #==============================================================================

# resource "azurerm_public_ip" "pip" {
#   name                = "f_pip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = "central india"
#   allocation_method   = "Static"
# }

# # Create backend public IP
# #==============================================================================

# # resource "azurerm_public_ip" "bpip" {
# #   name                = "b_pip"
# #   resource_group_name = azurerm_resource_group.rg.name
# #   location            = "central india"
# #   allocation_method   = "Static"
# # }

# # Create frontend network interfaces
# #==============================================================================

# resource "azurerm_network_interface" "nic" {
#   name                = "nic-test"
#   location            = "central india"
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.f_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip.id
#   }
# }

# Create a Key Vault
#==============================================================================

resource "azurerm_key_vault" "kv" {
  depends_on                  = [azurerm_resource_group.rg]
  name                        = "keyvault-test12345"
  location                    = "central india"
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
    ]

    secret_permissions = [
      "Get",
      "List",
    ]

    storage_permissions = [
      "Get",
      "List",
    ]
  }
}

# # Create frontend virtual machines
# #==============================================================================

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                = "frontend-vm"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = "central india"
#   size                = "Standard_D2s_v3"
#   admin_username      = "adminuser"
#   network_interface_ids = [
#     azurerm_network_interface.nic.id,
#     ]

#   disable_password_authentication = false
#   admin_password                  = "P@ssword1234"


#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }
# }

# # Create backend network interfaces
# #==============================================================================

# # resource "azurerm_network_interface" "b_nic" {
# #   name                = "b_nic_test"
# #   location            = "central india"
# #   resource_group_name = azurerm_resource_group.rg.name

# #   ip_configuration {
# #     name                          = "internal"
# #     subnet_id                     = data.azurerm_subnet.b_subnet.id
# #     private_ip_address_allocation = "Dynamic"
# #     public_ip_address_id          = azurerm_public_ip.bpip.id
# #   }
# # }

# # Create backend virtual machines
# #==============================================================================

# # resource "azurerm_linux_virtual_machine" "b_vm" {
# #   name                = "backend-vm"
# #   resource_group_name = azurerm_resource_group.rg.name
# #   location            = "central india"
# #   size                = "Standard_D2s_v3"
# #   admin_username      = "adminuser"
# #   network_interface_ids = [
# #     azurerm_network_interface.b_nic.id,
# #     ]

# #   disable_password_authentication = false
# #   admin_password                  = "P@ssword1234"


# #   os_disk {
# #     caching              = "ReadWrite"
# #     storage_account_type = "Standard_LRS"
# #   }

# #   source_image_reference {
# #     publisher = "Canonical"
# #     offer     = "0001-com-ubuntu-server-jammy"
# #     sku       = "22_04-lts-gen2"
# #     version   = "latest"
# #   }
# # }
