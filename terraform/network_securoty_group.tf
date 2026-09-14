resource "azurerm_network_security_group" "vm_nsg_01" {
  for_each = local.nsg_details

  name = each.key

  location            = each.value.location
  resource_group_name = azurerm_resource_group.vm_rg_01.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "vm_nsg_rule_01" {
  for_each = local.firewall_rule_details

  name = each.value.rule_name

  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol

  source_port_range      = each.value.source_port_range
  destination_port_range = each.value.destination_port_range

  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  resource_group_name = azurerm_resource_group.vm_rg_01.name

  network_security_group_name = azurerm_network_security_group.vm_nsg_01[
    "${each.value.nsg_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
  ].name
}


