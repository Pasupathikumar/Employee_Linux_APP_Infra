# =========================================================
# locals.tf
# =========================================================

locals {

  # ======================================================
  # VIRTUAL NETWORKS
  # ======================================================

  vnet_details = {

    for vnet in var.vnet_details :

    "${vnet.vnet_name}-${var.environment}-${var.project}-${vnet.location}-${vnet.instance}" => {

      vnet_name          = vnet.vnet_name
      vnet_deploy_flag   = vnet.vnet_deploy_flag
      location           = vnet.location
      instance           = vnet.instance
      vnet_address_space = vnet.vnet_address_space

    }

    if vnet.vnet_deploy_flag
  }


  # ======================================================
  # SUBNETS
  # ======================================================

  subnet_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : {

        vnet_name = vnet.vnet_name
        location  = vnet.location
        instance  = vnet.instance

        subnet_name          = subnet.subnet_name
        subnet_deploy_flag   = subnet.subnet_deploy_flag
        subnet_address_space = subnet.subnet_address_space

      }

    ]

  ])


  subnet_details = {

    for subnet in local.subnet_list :

    "${subnet.subnet_name}-${var.environment}-${var.project}-${subnet.location}-${subnet.instance}" => subnet

    if subnet.subnet_deploy_flag
  }


  # ======================================================
  # PUBLIC IP ADDRESSES
  # ======================================================

  public_ip_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for public_ip in subnet.public_ip_details : {

          public_ip_name        = public_ip.public_ip_name
          public_ip_deploy_flag = public_ip.public_ip_deploy_flag
          ip_allocation_method  = public_ip.ip_allocation_method
          sku                   = public_ip.sku

          subnet_name = subnet.subnet_name
          vnet_name   = vnet.vnet_name

          location = vnet.location
          instance = vnet.instance

        }

      ]

    ]

  ])


  public_ip_details = {

    for public_ip in local.public_ip_list :

    "${public_ip.public_ip_name}-${var.environment}-${var.project}-${public_ip.location}-${public_ip.instance}" => public_ip

    if public_ip.public_ip_deploy_flag
  }


  # ======================================================
  # NETWORK SECURITY GROUPS
  # ======================================================

  nsg_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for nsg in subnet.network_security_group_details : {

          nsg_name        = nsg.nsg_name
          nsg_deploy_flag = nsg.nsg_deploy_flag

          subnet_name = subnet.subnet_name
          vnet_name   = vnet.vnet_name

          location = vnet.location
          instance = vnet.instance

        }

      ]

    ]

  ])


  nsg_details = {

    for nsg in local.nsg_list :

    "${nsg.nsg_name}-${var.environment}-${var.project}-${nsg.location}-${nsg.instance}" => nsg

    if nsg.nsg_deploy_flag
  }


  # ======================================================
  # FIREWALL / NSG RULES
  # ======================================================

  firewall_rule_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for nsg in subnet.network_security_group_details : [

          for rule in nsg.firewall_rules : {

            firewall_rule_deploy_flag = rule.firewall_rule_deploy_flag

            rule_name = rule.rule_name
            priority  = rule.priority
            direction = rule.direction
            access    = rule.access
            protocol  = rule.protocol

            source_port_range          = rule.source_port_range
            destination_port_range     = rule.destination_port_range
            source_address_prefix      = rule.source_address_prefix
            destination_address_prefix = rule.destination_address_prefix

            nsg_name = nsg.nsg_name

            location = vnet.location
            instance = vnet.instance

          }

        ]

      ]

    ]

  ])


  firewall_rule_details = {

    for rule in local.firewall_rule_list :

    "${rule.nsg_name}-${rule.rule_name}-${var.environment}-${var.project}-${rule.location}-${rule.instance}" => rule

    if rule.firewall_rule_deploy_flag
  }


  # ======================================================
  # NETWORK INTERFACES
  # ======================================================

  nic_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for nic in subnet.network_interface_details : {

          nic_name        = nic.nic_name
          nic_deploy_flag = nic.nic_deploy_flag

          private_ip_address = nic.private_ip_address

          public_ip_name = nic.public_ip_name
          nsg_name       = nic.nsg_name

          subnet_name = subnet.subnet_name
          vnet_name   = vnet.vnet_name

          location = vnet.location
          instance = vnet.instance

        }

      ]

    ]

  ])


  nic_details = {

    for nic in local.nic_list :

    "${nic.nic_name}-${var.environment}-${var.project}-${nic.location}-${nic.instance}" => nic

    if nic.nic_deploy_flag
  }


  # ======================================================
  # LINUX VIRTUAL MACHINES
  # ======================================================

  linux_vm_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for vm in subnet.linux_vm_details : {

          vm_deploy_flag = vm.vm_deploy_flag

          vm_name = vm.vm_name
          vm_size = vm.vm_size

          admin_username = vm.admin_username

          nic_name = vm.nic_name

          os_disk = vm.os_disk

          source_image_reference = vm.source_image_reference

          subnet_name = subnet.subnet_name
          vnet_name   = vnet.vnet_name

          location = vnet.location
          instance = vnet.instance

        }

      ]

    ]

  ])


  linux_vm_details = {

    for vm in local.linux_vm_list :

    "${vm.vm_name}-${var.environment}-${var.project}-${vm.location}-${vm.instance}" => vm

    if vm.vm_deploy_flag
  }

}