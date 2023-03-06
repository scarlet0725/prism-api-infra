variable "instance_name" {
  type        = string
  description = "Name of the instance"
}

variable "host" {
  type        = string
  description = "Host of the instance"
}

variable "password" {
  type        = string
  description = "Password of the instance"
  sensitive = true
}

variable "username" {
  type       = string
  description = "Username of the instance"
}