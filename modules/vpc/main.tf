resource "google_compute_network" "main" {
  name = var.name
  auto_create_subnetworks = false
}

resource "google_compute_router" "main" {
  name    = "${var.name}-router"
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.name}-nat"
  router                             = google_compute_router.main.name
  region                             = google_compute_router.main.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}