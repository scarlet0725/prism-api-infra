locals {
  region                  = "asia-northeast1"
  cloudflare_zone_id      = "531feabce23e362c99e0627e140c548c"
  api_endpoint_name       = "prism-api.irofessional.io"
  project_id              = "prism-prod-372103"
  gke_k8s_ns              = "prism"
  gke_k8s_service_account = "prism"
  wi_sa_name              = "${local.gke_k8s_ns}/${local.gke_k8s_service_account}"
}
