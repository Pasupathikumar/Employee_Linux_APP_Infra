locals {
    flatten_vnet_details = flatten([
        for vnet in var.vnet_details : [
            {
                vnet_name             = vnet.vnet_name
                subnet_name           = vnet.subnet_name
                instance              = vnet.instance
                location              = vnet.location
                vnet_address_space    = vnet.vnet_address_space
                subnet_address_space  = vnet.subnet_address_space
            }
        ]
    ])
}

resource "azurerm_virtual_network" "vm_vnet_01" {
    for_each = { for vnet in local.flatten_vnet_details : "${vnet.vnet_name}-${var.environment}-${var.project}-${vnet.location}-${vnet.instance}" => vnet }

    name                = "${each.value.vnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
    address_space       = each.value.vnet_address_space
    location            = each.value.location
    resource_group_name = azurerm_resource_group.vm_rg_01.name
    tags                = var.tags

    subnet {
        name             = "${each.value.subnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
        address_prefixes = each.value.subnet_address_space
    }
}

