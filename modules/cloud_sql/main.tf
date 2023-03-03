resource "random_id" "suffix" {
  byte_length = 5
}

resource "google_sql_database_instance" "main" {
  name             = "${var.name}-${lower("${random_id.suffix.id}")}"
  database_version = var.db_engine
  region           = var.region

  settings {
    tier = var.instance_type

    availability_type = "ZONAL"

    disk_size = 10
    disk_autoresize = true
    ip_configuration {
        ipv4_enabled = var.allocate_public_ip
        private_network = var.network_id
    }

    database_flags {
      name = "default_time_zone"
      value = "Asia/Tokyo"
    }

    database_flags {
      name = "character_set_server"
      value = "utf8mb4"
    }

    insights_config {
      query_insights_enabled = true
    }
  }
}
