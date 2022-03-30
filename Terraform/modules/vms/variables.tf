# Number of web servers to create
variable "prefix" {
  type = string
}
variable "location" {
  type = string
}
variable "rg-name" {
  type = string
}
variable "WebTierNSG_id" {
  type = string
}
variable "DataTierNSG_id" {
  type = string
}
variable "instance_count" {
  type = number
}
variable "vm_size" {
  type = string
}
# Default VM user
variable "admin-user" {
  type = string
}
# Default VM user
variable "admin-password" {
  type = string
}

