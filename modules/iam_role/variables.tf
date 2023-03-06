variable "roles" {
  type        = list(string)
    description = "List of roles to be assigned to the service account"
}

variable "service_account" {
  type        = string
  description = "Name of the service account"
}

variable "project_id" {
  type        = string
  description = "Name of the project"
}
  