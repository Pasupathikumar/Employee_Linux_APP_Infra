resource "azurerm_linux_virtual_machine" "vm_linux_01" {
  for_each = local.linux_vm_details

  name = each.key

  location            = each.value.location
  resource_group_name = azurerm_resource_group.vm_rg_01.name

  size = each.value.vm_size

  admin_username = each.value.admin_username
  admin_password = var.linux_vm_password

  disable_password_authentication = false
  network_interface_ids = [

    azurerm_network_interface.vm_nic_01[
      "${each.value.nic_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
    ].id
  ]

  os_disk {
    caching = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
    disk_size_gb = each.value.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer = each.value.source_image_reference.offer
    sku = each.value.source_image_reference.sku
    version = each.value.source_image_reference.version
  }

  tags = var.tags

  depends_on = [
    azurerm_network_interface.vm_nic_01
  ]
}