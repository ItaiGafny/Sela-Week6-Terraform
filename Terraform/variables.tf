# Prefix name for all resources in resource group
variable "prefix" {
  type = map(string)
}

# Default location for all resources
variable "location" {
  type = map(string)
}

# Number of virtuall machines in the HA zone
variable "instance_count" {
  type = number
}

# Default VM user
variable "admin-user" {
  type = string
}
# Default VM user
variable "admin-password" {
  type = string
}

variable "resource_group_name" {
  type = map(string)
}

variable "vm_size" {
  type = map(string)
}

# Allowed IP address
variable "my_ip_address" {
  type = set(string)
}