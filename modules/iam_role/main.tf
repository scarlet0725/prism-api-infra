resource "google_project_iam_member" "cluster_admin" {
  project = var.project_id
  member  = "serviceAccount:${var.service_account}"
  for_each = toset(var.roles)
  role    = each.value
}