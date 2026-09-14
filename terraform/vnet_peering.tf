resource "azurerm_virtual_network_peering" "vm_vnet_peering_01" {
  for_each = local.vnet_peering_details

  name = each.value.peering_name
  resource_group_name = azurerm_resource_group.vm_rg_01.name

  virtual_network_name = azurerm_virtual_network.vm_vnet_01[
    "${each.value.source_vnet_name}-${var.environment}-${var.project}-${each.value.source_location}-${each.value.source_instance}"
  ].name

  remote_virtual_network_id = azurerm_virtual_network.vm_vnet_01[
    "${each.value.remote_vnet_name}-${var.environment}-${var.project}-${each.value.remote_vnet_location}-${each.value.remote_vnet_instance}"
  ].id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic = each.value.allow_forwarded_traffic
  allow_gateway_transit = each.value.allow_gateway_transit
  use_remote_gateways = each.value.use_remote_gateways
}