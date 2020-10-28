resource "google_sql_database_instance" "default" {
  name   = "${var.project_id}-db-${random_id.google_sql_database.hex}"
  region = var.region
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"

    ip_configuration {
      authorized_networks {
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "random_id" "google_sql_database" {
  byte_length = 8
}

resource "google_sql_database" "default" {
  name     = var.sql_db_name
  instance = google_sql_database_instance.default.name

  depends_on = [google_sql_database_instance.default]
}

resource "google_sql_user" "default" {
  name     = var.sql_user.username
  instance = google_sql_database_instance.default.name
  host     = "%"
  password = var.sql_user.password

  depends_on = [google_sql_database_instance.default]
}
