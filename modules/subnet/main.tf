resource "google_compute_subnetwork" "subnet" {
  name          = var.name
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = var.network_id

  stack_type = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"

  private_ip_google_access = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"

}