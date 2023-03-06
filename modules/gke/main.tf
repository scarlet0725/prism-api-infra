resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.location

  enable_autopilot = true
  network = var.network_id

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "126.78.253.9/32"
      display_name = "Home"
      }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
  }
  
  binary_authorization {
    evaluation_mode = "DISABLED"
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

}
