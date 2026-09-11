variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "location" {
  type        = string
  description = "Default Azure region"
}

variable "instance" {
  type        = string
  description = "Default instance number"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources"
}

variable "resource_group_rbac" {

  type = list(object({
    role_definition_name = string
    principal_id         = list(string)
  }))

  default     = []
  description = "List of role assignments for the resource group"
}

# VNET / SUBNET / VM CONFIGURATION
variable "vnet_details" {

  type = list(object({

    vnet_deploy_flag   = bool
    vnet_name          = string
    instance           = string
    location           = string
    vnet_address_space = list(string)

    vnet_peering_details = optional(list(object({
      peering_deploy_flag       = bool
      peering_name              = string

      remote_vnet_name          = string
      remote_vnet_location      = string
      remote_vnet_instance      = string

      allow_virtual_network_access = optional(bool, true)
      allow_forwarded_traffic      = optional(bool, false)
      allow_gateway_transit        = optional(bool, false)
      use_remote_gateways          = optional(bool, false)
    })), [])

    subnet_details = list(object({

      subnet_deploy_flag   = bool
      subnet_name          = string
      subnet_address_space = list(string)

      # Service Endpoints
      service_endpoints = optional(
        list(string),
        []
      )

      # Subnet Delegation
      delegated_details = optional(list(object({
        delegated_name = string
        service_delegation_details = object({
          service = string
          actions = list(string)
        })
      })), [])

      # Private DNS
      dns_zone_details = optional(list(object({
        dns_deploy_flag   = bool
        dns_zone_name     = string
        dns_zone_link_name = string
      })), [])
      
      # PostgreSQL Flexible Server
      postgresql_server_details = optional(list(object({
        postgresql_deploy_flag = bool
        postgresql_server_name = string
        postgresql_version = string
        postgresql_sku_name = string
        postgresql_storage_tier = string
        postgresql_storage_mb = number
        postgresql_admin_username = string
        postgresql_zone = string
        postgresql_public_access = bool

        dns_zone_name = string

        postgresql_database_details = optional(list(object({
          postgresql_database_deploy_flag = bool
          postgresql_database_name = string
          collation_name = string
          charset_name = string
        })), [])
      })), [])

      network_security_group_details = optional(list(object({
        nsg_deploy_flag = bool
        nsg_name = string
        firewall_rules = optional(list(object({
          firewall_rule_deploy_flag = optional(bool, true)
          rule_name = string
          priority = number
          direction = string
          access = string
          protocol = string
          source_port_range = string
          destination_port_range = string
          source_address_prefix = string
          destination_address_prefix = string
        })), [])
      })), [])

      public_ip_details = optional(list(object({
        public_ip_deploy_flag = bool
        public_ip_name = string
        ip_allocation_method = string
        sku = string
      })), [])

      network_interface_details = optional(list(object({
        nic_deploy_flag = bool
        nic_name = string
        private_ip_allocation_method = optional(string)
        public_ip_name = optional(string)
        nsg_name = optional(string)
      })), [])

      linux_vm_details = optional(list(object({
        vm_deploy_flag = bool
        vm_name = string
        vm_size = string
        admin_username = string
        nic_name = string
        os_disk = object({
          caching = string
          storage_account_type = string
          disk_size_gb = optional(number)
        })

        source_image_reference = object({
          publisher = string
          offer = string
          sku = string
          version = string
        })
      })), [])
    }))
  }))

  description = "Virtual network and virtual machine configuration"
}


variable "linux_vm_password" {
  type = string
  sensitive = true
  description = "Password for Linux virtual machines"
}


variable "postgresql_admin_password" {
  type = string
  sensitive = true
  description = "Administrator password for PostgreSQL Flexible Server"
}