resource "google_sql_user" "main" {
  name = var.username
  instance = var.instance_name
  password = var.password
}   