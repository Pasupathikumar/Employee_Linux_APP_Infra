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

      vnet_name = vnet.vnet_name

      vnet_deploy_flag = vnet.vnet_deploy_flag

      location = vnet.location

      instance = vnet.instance

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

        location = vnet.location

        instance = vnet.instance

        subnet_name = subnet.subnet_name

        subnet_deploy_flag = subnet.subnet_deploy_flag

        subnet_address_space = subnet.subnet_address_space

        service_endpoints = subnet.service_endpoints

        delegated_details = subnet.delegated_details
      }
    ]
  ])


  subnet_details = {

    for subnet in local.subnet_list :

    "${subnet.subnet_name}-${var.environment}-${var.project}-${subnet.location}-${subnet.instance}" => subnet

    if subnet.subnet_deploy_flag
  }


  # ======================================================
  # PRIVATE DNS ZONES
  # ======================================================

  dns_zone_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for dns in subnet.dns_zone_details : {

          dns_deploy_flag = dns.dns_deploy_flag

          dns_zone_name = dns.dns_zone_name

          dns_zone_link_name = dns.dns_zone_link_name

          subnet_name = subnet.subnet_name

          vnet_name = vnet.vnet_name

          location = vnet.location

          instance = vnet.instance
        }
      ]
    ]
  ])


  dns_zone_details = {

    for dns in local.dns_zone_list :

    "${dns.dns_zone_name}-${var.environment}-${var.project}-${dns.location}-${dns.instance}" => dns

    if dns.dns_deploy_flag
  }


  # ======================================================
  # POSTGRESQL SERVERS
  # ======================================================

  postgresql_server_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for postgres in subnet.postgresql_server_details : {

          postgresql_deploy_flag = postgres.postgresql_deploy_flag

          postgresql_server_name = postgres.postgresql_server_name

          postgresql_version = postgres.postgresql_version

          postgresql_sku_name = postgres.postgresql_sku_name

          postgresql_storage_tier = postgres.postgresql_storage_tier

          postgresql_storage_mb = postgres.postgresql_storage_mb

          postgresql_admin_username = postgres.postgresql_admin_username

          postgresql_zone = postgres.postgresql_zone

          postgresql_public_access = postgres.postgresql_public_access

          dns_zone_name = postgres.dns_zone_name

          subnet_name = subnet.subnet_name

          vnet_name = vnet.vnet_name

          location = vnet.location

          instance = vnet.instance
        }
      ]
    ]
  ])


  postgresql_server_details = {

    for postgres in local.postgresql_server_list :

    "${postgres.postgresql_server_name}-${var.environment}-${var.project}-${postgres.location}-${postgres.instance}" => postgres

    if postgres.postgresql_deploy_flag
  }


  # ======================================================
  # POSTGRESQL DATABASES
  # ======================================================

  postgresql_database_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for postgres in subnet.postgresql_server_details : [

          for database in postgres.postgresql_database_details : {

            postgresql_database_deploy_flag = database.postgresql_database_deploy_flag

            postgresql_database_name = database.postgresql_database_name

            collation_name = database.collation_name

            charset_name = database.charset_name

            postgresql_server_name = postgres.postgresql_server_name

            location = vnet.location

            instance = vnet.instance
          }
        ]
      ]
    ]
  ])


  postgresql_database_details = {

    for database in local.postgresql_database_list :

    "${database.postgresql_server_name}-${database.postgresql_database_name}-${var.environment}-${var.project}-${database.location}-${database.instance}" => database

    if database.postgresql_database_deploy_flag
  }


  # ======================================================
  # PUBLIC IP ADDRESSES
  # ======================================================

  public_ip_list = flatten([

    for vnet in var.vnet_details : [

      for subnet in vnet.subnet_details : [

        for public_ip in subnet.public_ip_details : {

          public_ip_name = public_ip.public_ip_name

          public_ip_deploy_flag = public_ip.public_ip_deploy_flag

          ip_allocation_method = public_ip.ip_allocation_method

          sku = public_ip.sku

          subnet_name = subnet.subnet_name

          vnet_name = vnet.vnet_name

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

          nsg_name = nsg.nsg_name

          nsg_deploy_flag = nsg.nsg_deploy_flag

          subnet_name = subnet.subnet_name

          vnet_name = vnet.vnet_name

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

            priority = rule.priority

            direction = rule.direction

            access = rule.access

            protocol = rule.protocol

            source_port_range = rule.source_port_range

            destination_port_range = rule.destination_port_range

            source_address_prefix = rule.source_address_prefix

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

          nic_name = nic.nic_name

          nic_deploy_flag = nic.nic_deploy_flag

          private_ip_allocation_method = nic.private_ip_allocation_method

          public_ip_name = nic.public_ip_name

          nsg_name = nic.nsg_name

          subnet_name = subnet.subnet_name

          vnet_name = vnet.vnet_name

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

          vnet_name = vnet.vnet_name

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

  # ======================================================
# VNET PEERING
# ======================================================

vnet_peering_list = flatten([
  for vnet in var.vnet_details : [
    for peering in vnet.vnet_peering_details : {
      peering_deploy_flag = peering.peering_deploy_flag
      peering_name        = peering.peering_name

      source_vnet_name     = vnet.vnet_name
      source_location      = vnet.location
      source_instance      = vnet.instance

      remote_vnet_name     = peering.remote_vnet_name
      remote_vnet_location = peering.remote_vnet_location
      remote_vnet_instance = peering.remote_vnet_instance

      allow_virtual_network_access = peering.allow_virtual_network_access
      allow_forwarded_traffic      = peering.allow_forwarded_traffic
      allow_gateway_transit        = peering.allow_gateway_transit
      use_remote_gateways          = peering.use_remote_gateways
    }
  ]
])

vnet_peering_details = {
  for peering in local.vnet_peering_list :

  "${peering.peering_name}-${var.environment}-${var.project}-${peering.source_location}-${peering.source_instance}" => peering

  if peering.peering_deploy_flag
}
}