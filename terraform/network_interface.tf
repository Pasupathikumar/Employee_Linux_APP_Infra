resource "azurerm_network_interface" "vm_nic_01" {
  for_each = local.nic_details

  name = each.key

  location            = each.value.location
  resource_group_name = azurerm_resource_group.vm_rg_01.name

  ip_configuration {
    name = "ipconfig01"
    subnet_id = azurerm_subnet.vm_subnet_01[
      "${each.value.subnet_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
    ].id

    private_ip_address_allocation = each.value.private_ip_allocation_method

    public_ip_address_id = (
      each.value.public_ip_name != null
      ?
      azurerm_public_ip.vm_public_ip_01[
        "${each.value.public_ip_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
      ].id
      :
      null
    )
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "vm_nic_nsg_association_01" {
  for_each = {
    for key, nic in local.nic_details :
    key => nic
    if nic.nsg_name != null
  }

  network_interface_id = azurerm_network_interface.vm_nic_01[
    each.key
  ].id

  network_security_group_id = azurerm_network_security_group.vm_nsg_01[
    "${each.value.nsg_name}-${var.environment}-${var.project}-${each.value.location}-${each.value.instance}"
  ].id
}
