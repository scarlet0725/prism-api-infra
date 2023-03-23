#GKEクラスター用のVPCを作成

module "vpc" {
  source = "./modules/vpc"

  name = "prism-api-vpc"
}

#VPC内にサブネットを作成
module "subnet" {
  source = "./modules/subnet"

  name          = "prism-api-subnet"
  network_id    = module.vpc.vpc_id
  ip_cidr_range = "10.150.0.0/16"
  region        = local.region
}

#Peeringする
module "vpc_connection" {
  source = "./modules/vpc_connection"

  network_id              = module.vpc.vpc_id
  private_ip_address_name = "prism-api-private-ip-address"
}

#Cloud SQLのインスタンスを作成
module "sql" {
  source = "./modules/cloud_sql"

  name          = "prism-api-sql"
  db_engine     = "MYSQL_8_0"
  instance_type = "db-f1-micro"
  network_id    = module.vpc.vpc_id
  region        = local.region
}

#Cloud SQLのデータベースを作成
module "prism_databse" {
  source = "./modules/cloud_sql_db"

  databse_name  = "prism_api"
  instance_name = module.sql.instance.name
}

#CloudSQL用のパスワードを作成
resource "random_password" "password" {
  length  = 16
  special = true
}

#Cloud SQLのユーザーを作成
module "prism_user" {
  source = "./modules/cloud_sql_user"

  username      = "prism_user"
  password      = random_password.password.result
  instance_name = module.sql.instance.name
  host          = "%"
}

#GKEクラスターを作成
module "cluster" {
  source = "./modules/gke"

  cluster_name = "prism"
  location     = local.region
  network_id   = module.vpc.vpc_id

}

#GKEクラスター用のService Accountを作成
resource "google_service_account" "service_account" {
  account_id   = "prism-api"
  display_name = "prism API Service Account"
}

#GKEクラスター用のService Accountに権限を付与
module "sa_iam_binding" {
  source = "./modules/iam_role"

  service_account = google_service_account.service_account.email
  roles           = ["roles/cloudsql.client"]

  project_id = local.project_id
}

#GKEクラスター用のService AccountにWorkload Identityを付与
resource "google_service_account_iam_binding" "wi_iam_binding" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${local.project_id}.svc.id.goog[${local.wi_sa_name}]"]
}

#GKE Gateway用の証明書を作成
module "cert" {
  source = "./modules/gcp_managed_certificate"

  name = "prism-api-cert"
  domains = [
    local.api_endpoint_name
  ]
}

#GKE Gateway用のIPアドレスを作成
resource "google_compute_global_address" "main" {
  name = "prism-gke-gateway"
}

#IPアドレスをCloudflareに登録
resource "cloudflare_record" "record" {
  zone_id = local.cloudflare_zone_id
  name    = local.api_endpoint_name
  type    = "A"
  value   = google_compute_global_address.main.address
  proxied = false
  ttl     = 60

  comment = "managed by terraform"
}
