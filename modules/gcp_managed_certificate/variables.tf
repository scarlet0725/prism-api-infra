variable "name" {
  type        = string
  description = "Name of the managed certificate"
}

variable "domains" {
  type        = list(string)
  description = "List of domains to be included in the certificate"
}
  