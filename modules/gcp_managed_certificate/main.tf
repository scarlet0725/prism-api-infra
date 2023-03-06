resource "google_compute_managed_ssl_certificate" "main" {
  name = var.name

  managed {
    domains = var.domains
  }
}