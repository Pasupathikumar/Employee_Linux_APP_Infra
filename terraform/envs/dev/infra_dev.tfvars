# =========================================================
# terraform.tfvars
# =========================================================

project     = "employee-api"
environment = "dev"
location    = "southindia"
instance    = "01"

resource_group_name = "rg"

tags = {
  Project     = "Employee API"
  Environment = "Development"
}

resource_group_rbac = []

vnet_details = [

  # ======================================================
  # VNET 01
  # ======================================================

  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet"
    vnet_address_space = ["10.10.0.0/16"]
    instance           = "01"
    location           = "southindia"

    subnet_details = [

      {
        subnet_deploy_flag   = true
        subnet_name          = "subnet"
        subnet_address_space = ["10.10.1.0/24"]

        network_security_group_details = [
          {
            nsg_deploy_flag = true
            nsg_name        = "nsg"

            firewall_rules = [
              {
                firewall_rule_deploy_flag  = true
                rule_name                  = "allow-ssh"
                priority                   = 1000
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

        public_ip_details = [
          {
            public_ip_deploy_flag = true
            public_ip_name        = "public-ip"
            ip_allocation_method  = "Static"
            sku                   = "Standard"
          }
        ]

        network_interface_details = [
          {
            nic_deploy_flag = true
            nic_name        = "nic"

            private_ip_address = null
            public_ip_name      = "public-ip"
            nsg_name            = "nsg"
          }
        ]

        linux_vm_details = [
          {
            vm_deploy_flag = true

            vm_name = "linux-vm"
            vm_size = "Standard_B2s"

            admin_username = "pasupathi"

            nic_name = "nic"

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


  # ======================================================
  # VNET 02
  # ======================================================

  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet"
    vnet_address_space = ["10.20.0.0/16"]
    instance           = "02"
    location           = "eastus"

    subnet_details = [
      {
        subnet_deploy_flag   = true
        subnet_name          = "subnet"
        subnet_address_space = ["10.20.1.0/24"]

        network_security_group_details = [
          {
            nsg_deploy_flag = true
            nsg_name        = "nsg"
          }
        ]

        public_ip_details = [
          {
            public_ip_deploy_flag = true
            public_ip_name        = "public-ip"
            ip_allocation_method  = "Static"
            sku                   = "Standard"
          }
        ]

        network_interface_details = [
          {
            nic_deploy_flag = true
            nic_name        = "nic"

            public_ip_name = "public-ip"
            nsg_name       = "nsg"
          }
        ]

        linux_vm_details = [
          {
            vm_deploy_flag = true

            vm_name = "linux-vm"
            vm_size = "Standard_B2s"

            admin_username = "pasupathi"

            nic_name = "nic"

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


  # ======================================================
  # VNET 03
  # ======================================================

  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet"
    vnet_address_space = ["10.30.0.0/16"]
    instance           = "03"
    location           = "westus"

    subnet_details = [
      {
        subnet_deploy_flag   = true
        subnet_name          = "subnet"
        subnet_address_space = ["10.30.1.0/24"]

        network_security_group_details = [
          {
            nsg_deploy_flag = true
            nsg_name        = "nsg"
          }
        ]

        public_ip_details = [
          {
            public_ip_deploy_flag = true
            public_ip_name        = "public-ip"
            ip_allocation_method  = "Static"
            sku                   = "Standard"
          }
        ]

        network_interface_details = [
          {
            nic_deploy_flag = true
            nic_name        = "nic"

            public_ip_name = "public-ip"
            nsg_name       = "nsg"
          }
        ]

        linux_vm_details = [
          {
            vm_deploy_flag = true

            vm_name = "linux-vm"
            vm_size = "Standard_B2s"

            admin_username = "pasupathi"

            nic_name = "nic"

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


  # ======================================================
  # VNET 04
  # ======================================================

  {
    vnet_deploy_flag   = true
    vnet_name          = "vnet"
    vnet_address_space = ["10.40.0.0/16"]
    instance           = "04"
    location           = "westcentralus"

    subnet_details = [
      {
        subnet_deploy_flag   = true
        subnet_name          = "subnet"
        subnet_address_space = ["10.40.1.0/24"]

        network_security_group_details = [
          {
            nsg_deploy_flag = true
            nsg_name        = "nsg"
          }
        ]

        public_ip_details = [
          {
            public_ip_deploy_flag = true
            public_ip_name        = "public-ip"
            ip_allocation_method  = "Static"
            sku                   = "Standard"
          }
        ]

        network_interface_details = [
          {
            nic_deploy_flag = true
            nic_name        = "nic"

            public_ip_name = "public-ip"
            nsg_name       = "nsg"
          }
        ]

        linux_vm_details = [
          {
            vm_deploy_flag = true

            vm_name = "linux-vm"
            vm_size = "Standard_B2s"

            admin_username = "pasupathi"

            nic_name = "nic"

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
  }
]