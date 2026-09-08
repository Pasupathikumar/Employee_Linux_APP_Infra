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
    description = "Azure region for the resources"
}

variable "instance" {
    type        = string
    description = "instance number for all resources"
}

variable "resource_group_name" {
    type        = string
    description = "Name of the resource group"
}

variable "tags" {
    type        = map(string)
    description = "Tags to be applied to resources"
    default     = {
        "Project"     = var.project
        "Environment" = var.environment
        "Instance"    = var.instance
    }
}

variable "resource_group_rbac" {
    type = list(object({
        role_definition_name = string
        principal_id         = list(string)
    }))
    description = "List of role assignments for the resource group"
}

variable "vnet_details" {
    type        = list(object({
        vnet_name = string
        subnet_name = string
        instace = string
        location = string
        vnet_address_space = list(string)
        subnet_address_space = list(string)
    }))
    description = "Name of the Virtual Network"
}
