variable "network_id" {
  type        = string
  description = "The ID of the network to attach this subnet to."
}

variable "name" {
  type       = string
    description = "Name of the subnet"
}

variable "region" {
  type        = string
  description = "The region this subnet should be located in."
}

variable "ip_cidr_range" {
  type        = string
  description = "The IP address range that machines in this subnet can use."
}