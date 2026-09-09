# =========================================================
# PostgreSQL Private DNS Zones
# =========================================================

resource "azurerm_private_dns_zone" "postgresql_dns_zones" {

  for_each = local.dns_zone_details

  name = each.value.dns_zone_name

  resource_group_name = azurerm_resource_group.vm_rg_01.name

  tags = var.tags
}


# =========================================================
# PostgreSQL DNS Zone -> VNet Link
# =========================================================

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_dns_zone_link" {

  for_each = local.dns_zone_details

  name = each.value.dns_zone_link_name

  resource_group_name = azurerm_resource_group.vm_rg_01.name

  private_dns_zone_name = azurerm_private_dns_zone.postgresql_dns_zones[
    each.key
  ].name

  virtual_network_id = azurerm_virtual_network.vm_vnet_01[
    "${each.value.vnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
  ].id

  registration_enabled = false
}