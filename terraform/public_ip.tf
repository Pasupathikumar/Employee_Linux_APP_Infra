# =========================================================
# Public IP
# =========================================================

resource "azurerm_public_ip" "vm_public_ip_01" {

  for_each = local.public_ip_details

  name = each.key

  location            = each.value.location
  resource_group_name = azurerm_resource_group.vm_rg_01.name

  allocation_method = each.value.ip_allocation_method
  sku               = each.value.sku

  tags = var.tags
}
