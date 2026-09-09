# =========================================================
# terraform.tfvars / infra_dev.tfvars
# =========================================================

project     = "employee-api"
environment = "dev"
location    = "southindia"
instance    = "01"

resource_group_name = "rg"

tags = {
  Project     = "Employee API"
  Environment = "Development"
  ManagedBy   = "Terraform"
  Application = "Employee Management"
}

resource_group_rbac = []

# =========================================================
# VIRTUAL NETWORK DETAILS
# =========================================================
vnet_details = [
  # =======================================================
  # VNET 01 - WEB SERVER
  # =======================================================
  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet-web"
    vnet_address_space = ["10.10.0.0/16"]
    instance           = "01"
    location           = "southindia"

    subnet_details = [
      {
        subnet_deploy_flag   = true
        subnet_name          = "snet-web"
        subnet_address_space = ["10.10.1.0/24"]

        service_endpoints = []

        delegated_details = []

        dns_zone_details = []

        postgresql_server_details = []

        # =================================================
        # WEB NSG
        # =================================================
        network_security_group_details = [
          {
            nsg_deploy_flag = true
            nsg_name        = "nsg-web"

            firewall_rules = [
              # -------------------------------------------
              # HTTP
              # -------------------------------------------
              {
                firewall_rule_deploy_flag  = true
                rule_name                  = "allow-http"
                priority                   = 100
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_port_range          = "*"
                destination_port_range     = "80"
                source_address_prefix      = "*"
                destination_address_prefix = "*"
              },

              # -------------------------------------------
              # HTTPS
              # -------------------------------------------

              {
                firewall_rule_deploy_flag  = true
                rule_name                  = "allow-https"
                priority                   = 110
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_port_range          = "*"
                destination_port_range     = "443"
                source_address_prefix      = "*"
                destination_address_prefix = "*"
              },

              # -------------------------------------------
              # SSH from Admin subnet
              # -------------------------------------------

              {
                firewall_rule_deploy_flag  = true
                rule_name                  = "allow-ssh-from-admin"
                priority                   = 120
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_port_range          = "*"
                destination_port_range     = "22"
                source_address_prefix      = "10.30.1.0/24"
                destination_address_prefix = "*"
              }

            ]
          }
        ]

        # =================================================
        # WEB PUBLIC IP
        # =================================================
        public_ip_details = [
          {
            public_ip_deploy_flag = true
            public_ip_name        = "pip-web"
            ip_allocation_method  = "Static"
            sku                   = "Standard"
          }
        ]

        # =================================================
        # WEB NIC
        # =================================================
        network_interface_details = [
          {
            nic_deploy_flag = true
            nic_name        = "nic-web"
            private_ip_allocation_method = "Dynamic"
            public_ip_name = "pip-web"
            nsg_name = "nsg-web"
          }
        ]

        # =================================================
        # WEB LINUX VM
        # =================================================
        linux_vm_details = [
          {
            vm_deploy_flag = true
            vm_name = "web01"
            vm_size = "Standard_B2s"
            admin_username = "pasupathi"
            nic_name = "nic-web"

            os_disk = {
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
              disk_size_gb         = 30
            }

            source_image_reference = {
              publisher = "Canonical"
              offer     = "0001-com-ubuntu-server-jammy"
              sku       = "22_04-lts-gen2"
              version   = "latest"
            }
          }
        ]
      }
    ]
  },

  # =======================================================
  # VNET 02 - APPLICATION SERVER
  # =======================================================
  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet-app"
    vnet_address_space = ["10.20.0.0/16"]
    instance           = "02"
    location           = "southindia"

    subnet_details = [
      {
        subnet_deploy_flag   = true
        subnet_name          = "snet-app"
        subnet_address_space = ["10.20.1.0/24"]

        service_endpoints = []

        delegated_details = []

        dns_zone_details = []

        postgresql_server_details = []

        # =================================================
        # APP NSG
        # =================================================
        network_security_group_details = [
          {
            nsg_deploy_flag = true
            nsg_name        = "nsg-app"

            firewall_rules = [
              # -------------------------------------------
              # Application API from Web server
              # -------------------------------------------
              {
                firewall_rule_deploy_flag  = true
                rule_name                  = "allow-api-from-web"
                priority                   = 100
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_port_range          = "*"
                destination_port_range     = "8080"
                source_address_prefix      = "10.10.1.0/24"
                destination_address_prefix = "*"
              },

              # -------------------------------------------
              # SSH from Admin subnet
              # -------------------------------------------
              {
                firewall_rule_deploy_flag  = true
                rule_name                  = "allow-ssh-from-admin"
                priority                   = 110
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_port_range          = "*"
                destination_port_range     = "22"
                source_address_prefix      = "10.30.1.0/24"
                destination_address_prefix = "*"
              }
            ]
          }
        ]

        # =================================================
        # APP PUBLIC IP
        #
        # No public IP required.
        # =================================================
        public_ip_details = []

        # =================================================
        # APP NIC
        # =================================================
        network_interface_details = [
          {
            nic_deploy_flag = true
            nic_name        = "nic-app"

            private_ip_allocation_method = "Dynamic"

            public_ip_name = null

            nsg_name = "nsg-app"
          }
        ]

        # =================================================
        # APP LINUX VM
        # =================================================
        linux_vm_details = [
          {
            vm_deploy_flag = true
            vm_name = "app01"
            vm_size = "Standard_B2s"
            admin_username = "pasupathi"
            nic_name = "nic-app"

            os_disk = {
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
              disk_size_gb         = 30
            }

            source_image_reference = {
              publisher = "Canonical"
              offer     = "0001-com-ubuntu-server-jammy"
              sku       = "22_04-lts-gen2"
              version   = "latest"
            }
          }
        ]
      }
    ]
  },

  # =======================================================
  # VNET 03 - ADMIN / MANAGEMENT SERVER
  # =======================================================
  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet-admin"
    vnet_address_space = ["10.30.0.0/16"]
    instance           = "03"
    location           = "southindia"

    subnet_details = [
      {
        subnet_deploy_flag   = true
        subnet_name          = "snet-admin"
        subnet_address_space = ["10.30.1.0/24"]

        service_endpoints = []

        delegated_details = []

        dns_zone_details = []

        postgresql_server_details = []

        # =================================================
        # ADMIN NSG
        # =================================================
        network_security_group_details = [
          {
            nsg_deploy_flag = true
            nsg_name        = "nsg-admin"

            firewall_rules = [
              # -------------------------------------------
              # SSH to Admin VM
              #
              # For learning/testing only.
              # Replace "*" with your public IP later.
              # -------------------------------------------
              {
                firewall_rule_deploy_flag  = true
                rule_name                  = "allow-admin-ssh"
                priority                   = 100
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_port_range          = "*"
                destination_port_range     = "22"
                source_address_prefix      = "*"
                destination_address_prefix = "*"
              }
            ]
          }
        ]

        # =================================================
        # ADMIN PUBLIC IP
        # =================================================
        public_ip_details = [
          {
            public_ip_deploy_flag = true
            public_ip_name        = "pip-admin"
            ip_allocation_method  = "Static"
            sku                   = "Standard"
          }
        ]

        # =================================================
        # ADMIN NIC
        # =================================================
        network_interface_details = [
          {
            nic_deploy_flag = true
            nic_name        = "nic-admin"

            private_ip_allocation_method = "Dynamic"

            public_ip_name = "pip-admin"

            nsg_name = "nsg-admin"
          }
        ]

        # =================================================
        # ADMIN LINUX VM
        # =================================================
        linux_vm_details = [
          {
            vm_deploy_flag = true
            vm_name = "admin01"
            vm_size = "Standard_B2s"
            admin_username = "pasupathi"
            nic_name = "nic-admin"

            os_disk = {
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
              disk_size_gb         = 30
            }

            source_image_reference = {
              publisher = "Canonical"
              offer     = "0001-com-ubuntu-server-jammy"
              sku       = "22_04-lts-gen2"
              version   = "latest"
            }
          }
        ]
      }
    ]
  },

  # =======================================================
  # VNET 04 - DATABASE
  # Azure Database for PostgreSQL Flexible Server
  # =======================================================
  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet-db"
    vnet_address_space = ["10.40.0.0/16"]
    instance           = "04"
    location           = "southindia"

    subnet_details = [
      {
        subnet_deploy_flag = true
        subnet_name = "snet-postgresql"
        subnet_address_space = [
          "10.40.1.0/24"
        ]

        # =================================================
        # SERVICE ENDPOINTS
        #
        # Not required for PostgreSQL delegated subnet.
        # =================================================
        service_endpoints = []

        # =================================================
        # POSTGRESQL SUBNET DELEGATION
        # =================================================

        delegated_details = [
          {
            delegated_name = "postgresql-delegation"
            service_delegation_details = {
              service = "Microsoft.DBforPostgreSQL/flexibleServers"
              actions = [
                "Microsoft.Network/virtualNetworks/subnets/join/action"
              ]
            }
          }
        ]

        # =================================================
        # PRIVATE DNS ZONE
        # =================================================
        dns_zone_details = [
          {
            dns_deploy_flag = true
            dns_zone_name = "employee-api.private.postgres.database.azure.com"
            dns_zone_link_name = "employee-api-postgresql-db-vnet-link"
          }
        ]


        # =================================================
        # POSTGRESQL FLEXIBLE SERVER
        # =================================================
        postgresql_server_details = [
          {
            postgresql_deploy_flag = true
            postgresql_server_name = "psql-employee-api-dev-01"
            postgresql_version = "16"
            postgresql_sku_name = "B_Standard_B1ms"
            postgresql_storage_tier = "P4"
            postgresql_storage_mb = 32768
            postgresql_admin_username = "psqladmin"
            postgresql_zone = "1"
            postgresql_public_access = false
            dns_zone_name = "employee-api.private.postgres.database.azure.com"


            # =============================================
            # EMPLOYEE DATABASE
            # =============================================
            postgresql_database_details = [
              {
                postgresql_database_deploy_flag = true
                postgresql_database_name = "employee_db"
                collation_name = "en_US.utf8"
                charset_name = "UTF8"
              }
            ]
          }
        ]


        # =================================================
        # NSG
        #
        # No NIC-based NSG required because PostgreSQL
        # Flexible Server is managed by Azure.
        # =================================================

        network_security_group_details = []


        # =================================================
        # PUBLIC IP
        #
        # PostgreSQL is private only.
        # =================================================

        public_ip_details = []


        # =================================================
        # NETWORK INTERFACE
        #
        # Flexible Server does not require our NIC resource.
        # =================================================

        network_interface_details = []


        # =================================================
        # LINUX VM
        #
        # No DB VM because PostgreSQL is Azure managed.
        # =================================================

        linux_vm_details = []
      }
    ]
  }

]