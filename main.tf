module "vpc" {
  source = "./modules/vpc"

  name = "prism-api-vpc"
}

module "subnet" {
  source = "./modules/subnet"

  name          = "prism-api-subnet"
  network_id    = module.vpc.vpc_id
  ip_cidr_range = "10.150.0.0/16"
  region        = local.region
}

module "vpc_connection" {
  source = "./modules/vpc_connection"

  network_id              = module.vpc.vpc_id
  private_ip_address_name = "prism-api-private-ip-address"
}

module "sql" {
  source = "./modules/cloud_sql"

  name          = "prism-api-sql"
  db_engine     = "MYSQL_8_0"
  instance_type = "db-f1-micro"
  network_id    = module.vpc.vpc_id
  region        = local.region
}

module "prism_databse" {
  source = "./modules/cloud_sql_db"

  databse_name  = "prism_api"
  instance_name = module.sql.instance.name
}

module "prism_user" {
  source = "./modules/cloud_sql_user"

  username      = "prism_user"
  password      = random_password.password.result
  instance_name = module.sql.instance.name
  host          = "%"
}

module "cluster" {
  source = "./modules/gke"

  cluster_name = "prism"
  location     = local.region
  network_id   = module.vpc.vpc_id

}

resource "random_password" "password" {
  length  = 16
  special = true
}

resource "google_service_account" "service_account" {
  account_id   = "prism-api"
  display_name = "prism API Service Account"
}

module "sa_iam_binding" {
  source = "./modules/iam_role"

  service_account = google_service_account.service_account.email
  roles           = ["roles/cloudsql.client"]

  project_id = local.project_id
}

locals {
  project_id   = "prism-prod-372103"
  gke_k8s_ns   = "prism"
  gke_k8s_service_account = "prism"
  wi_sa_name   = "${local.gke_k8s_ns}/${local.gke_k8s_service_account}"
}

resource "google_service_account_iam_binding" "wi_iam_binding" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${local.project_id}.svc.id.goog[${local.wi_sa_name}]"]
}

module "cert" {
  source = "./modules/gcp_managed_certificate"

  name = "prism-api-cert"
  domains = [
    "prism-api.irofessional.io"
  ]
}

resource "google_compute_global_address" "main" {
  name = "prism-gke-gateway"
}