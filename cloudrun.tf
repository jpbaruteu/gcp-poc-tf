resource "google_cloud_run_service" "default" {
  name     = "${var.project_id}-${var.environment}-srv"
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.default.connection_name
      }

      labels = {
        "gcb-trigger-id" = google_cloudbuild_trigger.default.trigger_id
      }
    }

    spec {
      service_account_name = "cloudrun@my-test-project-293907.iam.gserviceaccount.com"

      containers {
        image = "gcr.io/cloudrun/hello"

        env {
          name  = "CLOUD_SQL_CONNECTION_NAME"
          value = google_sql_database_instance.default.connection_name
        }

        env {
          name  = "INSTANCE_CONNECTION_NAME"
          value = google_sql_database_instance.default.connection_name
        }

        env {
          name  = "DB_HOST"
          value = google_sql_database_instance.default.public_ip_address
        }

        env {
          name  = "DB_USER"
          value = var.sql_user.username
        }

        env {
          name  = "DB_PASS"
          value = var.sql_user.password
        }

        env {
          name  = "DB_NAME"
          value = var.sql_db_name
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "member" {
  service  = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
