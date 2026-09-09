# =========================================================
# Virtual Network
# =========================================================

resource "azurerm_virtual_network" "vm_vnet_01" {

  for_each = local.vnet_details

  name = "${each.value.vnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"

  location = each.value.location

  resource_group_name = azurerm_resource_group.vm_rg_01.name

  address_space = each.value.vnet_address_space

  tags = var.tags
}


# =========================================================
# Subnet
# =========================================================

resource "azurerm_subnet" "vm_subnet_01" {

  for_each = local.subnet_details

  name = "${each.value.subnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"

  resource_group_name = azurerm_resource_group.vm_rg_01.name

  virtual_network_name = azurerm_virtual_network.vm_vnet_01[
    "${each.value.vnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
  ].name

  address_prefixes = each.value.subnet_address_space

  service_endpoints = each.value.service_endpoints


  dynamic "delegation" {

    for_each = each.value.delegated_details

    content {

      name = delegation.value.delegated_name

      service_delegation {

        name = delegation.value.service_delegation_details.service

        actions = delegation.value.service_delegation_details.actions
      }
    }
  }
}