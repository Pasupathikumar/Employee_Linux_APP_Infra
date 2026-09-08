locals {
    flatten_vnet_details = flatten([
        for vnet in var.vnet_details : [
            {
                vnet_name             = vnet.vnet_name
                subnet_name           = vnet.subnet_name
                instace               = vnet.instace
                location              = vnet.location
                vnet_address_space    = vnet.vnet_address_space
                subnet_address_space  = vnet.subnet_address_space
            }
        ]
    ])
}

resource "azurerm_virtual_network" "vm_vnet_01" {
    for_each = { for vnet in local.flatten_vnet_details : "${vnet.vnet_name}-${var.environment}-${var.project}-${vnet.location}-${vnet.instace}" => vnet }

    name                = "${each.value.vnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instace}"
    address_space       = each.value.vnet_address_space
    location            = each.value.location
    resource_group_name = azurerm_resource_group.vm_rg_01.name
    tags                = var.tags
}

resource "azurerm_subnet" "vm_subnet_01" {
    for_each = { for vnet in local.flatten_vnet_details : "${vnet.subnet_name}-${var.environment}-${var.project}-${vnet.location}-${vnet.instace}" => vnet }
    
    name                 = "${each.value.subnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instace}"
    resource_group_name  = azurerm_resource_group.vm_rg_01.name
    virtual_network_name = azurerm_virtual_network.vm_vnet_01["${each.value.vnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instace}"].name
    address_prefixes     = each.value.subnet_address_space
}