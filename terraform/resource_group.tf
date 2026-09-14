locals {
    resource_group_rbacs = flatten([
        for rbac in var.resource_group_rbac : [
            for principal_id in rbac.principal_id : {
                role_definition_name = rbac.role_definition_name
                principal_id         = principal_id
            }
        ]
    ])

}

resource "azurerm_resource_group" "vm_rg_01" {
  name = "${var.resource_group_name}-${var.environment}-${var.project}-${var.location}-${var.instance}"
  location = var.location

  tags = var.tags
}
resource "azurerm_role_assignment" "vm_rg_01_rbac" {
    for_each = { for rbac in local.resource_group_rbacs : "${rbac.role_definition_name}-${rbac.principal_id}" => rbac }

    scope                = azurerm_resource_group.vm_rg_01.id
    role_definition_name = each.value.role_definition_name
    principal_id         = each.value.principal_id
}