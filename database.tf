resource "random_id" "id" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name             = "db-v1-${random_id.id.hex}"
  database_version = "POSTGRES_12"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.network.self_link
    }
  }
}
