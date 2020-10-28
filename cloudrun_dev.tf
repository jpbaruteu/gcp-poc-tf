resource "google_cloud_run_service" "dev" {
  name     = "${var.project_id}-dev-srv"
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.dev.connection_name
      }

      labels = {
        "gcb-trigger-id" = google_cloudbuild_trigger.dev.trigger_id
      }
    }

    spec {
      service_account_name = google_service_account.cloudrun_service_account.email

      containers {
        image = "gcr.io/cloudrun/hello"

        env {
          name  = "CLOUD_SQL_CONNECTION_NAME"
          value = google_sql_database_instance.dev.connection_name
        }

        env {
          name  = "INSTANCE_CONNECTION_NAME"
          value = google_sql_database_instance.dev.connection_name
        }

        env {
          name  = "DB_HOST"
          value = google_sql_database_instance.dev.public_ip_address
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

  depends_on = [
    google_project_service.run,
    google_service_account.cloudrun_service_account,
  ]
}

resource "google_cloud_run_service_iam_member" "member_dev" {
  service  = google_cloud_run_service.dev.name
  location = google_cloud_run_service.dev.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
