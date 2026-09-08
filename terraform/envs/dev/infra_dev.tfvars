project = "employee-api"
environment = "dev"
location = "southindia"
instance = "01"

tags = {
    "Project"     = "Employee API"
    "Environment" = "Development"
}

resource_group_name = "rg"
resource_group_rbac = []

vnet_details = [
  {
    instance = "01"
    location = "southindia"
    subnet_address_space = [ "10.10.1.0/24" ]
    subnet_name = "subnet"
    vnet_address_space = [ "10.10.0.0/16" ]
    vnet_name = "vnet"
  },
  {
    instance = "02"
    location = "eastus"
    subnet_address_space = [ "10.20.1.0/24" ]
    subnet_name = "subnet"
    vnet_address_space = [ "10.20.0.0/16" ]
    vnet_name = "vnet"
  },
  {
    instance = "03"
    location = "westus"
    subnet_address_space = [ "10.30.1.0/24" ]
    subnet_name = "subnet"
    vnet_address_space = [ "10.30.0.0/16" ]
    vnet_name = "vnet"
  },
  {
    instance = "04"
    location = "westcentralus"
    subnet_address_space = [ "10.40.1.0/24" ]
    subnet_name = "subnet"
    vnet_address_space = [ "10.40.0.0/16" ]
    vnet_name = "vnet"
  }
]