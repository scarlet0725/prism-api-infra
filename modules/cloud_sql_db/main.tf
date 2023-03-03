resource "google_sql_database" "main" {
  name = var.databse_name
  instance = var.instance_name
}
  