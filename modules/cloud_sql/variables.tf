variable "name" {
  type        = string
  description = "Name of the Cloud SQL instance"
}

variable "db_engine" {
  type        = string
  description = "Database engine to use"
}
  
variable "region" {
  type       = string
    description = "Region to deploy the Cloud SQL instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use"
}
  
variable "network_id" {
  type        = string
  description = "ID of the network"
}

variable "allocate_public_ip" {
  type        = bool
  description = "Whether to allocate a public IP address"
  default     = false
}
  