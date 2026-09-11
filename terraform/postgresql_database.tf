resource "azurerm_postgresql_flexible_server" "postgresql_server" {

  for_each = local.postgresql_server_details

  name = each.value.postgresql_server_name
  resource_group_name = azurerm_resource_group.vm_rg_01.name
  location = each.value.location
  version = each.value.postgresql_version

  administrator_login = each.value.postgresql_admin_username
  administrator_password = var.postgresql_admin_password

  zone = each.value.postgresql_zone

  delegated_subnet_id = azurerm_subnet.vm_subnet_01[
    "${each.value.subnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
  ].id

  private_dns_zone_id = azurerm_private_dns_zone.postgresql_dns_zones[
    "${each.value.dns_zone_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
  ].id

  public_network_access_enabled = each.value.postgresql_public_access

  sku_name = each.value.postgresql_sku_name
  storage_mb = each.value.postgresql_storage_mb
  storage_tier = each.value.postgresql_storage_tier

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgresql_dns_zone_link
  ]
}

resource "azurerm_postgresql_flexible_server_database" "postgresql_database" {
  for_each = local.postgresql_database_details

  name = each.value.postgresql_database_name

  server_id = azurerm_postgresql_flexible_server.postgresql_server[
    "${each.value.postgresql_server_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
  ].id

  charset = each.value.charset_name
  collation = each.value.collation_name

  depends_on = [ azurerm_postgresql_flexible_server.postgresql_server ]
}