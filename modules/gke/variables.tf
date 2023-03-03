variable "cluster_name" {
    type        = string
    description = "Name of the GKE cluster"
}

variable "location" {
    type        = string
    description = "Location of the GKE cluster"
}
  
variable "network_id" {
    type        = string
    description = "Network ID of the GKE cluster"
}
