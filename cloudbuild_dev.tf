resource "google_cloudbuild_trigger" "dev" {
  name = "dev"
  trigger_template {
    branch_name = "dev"
    repo_name   = var.git_repo
    dir         = "app"
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/${var.project_id}/app:${COMMIT_REF_NAME}_${COMMIT_SHA}", "."]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "run",
        "gcr.io/${var.project_id}/app:${COMMIT_REF_NAME}_${COMMIT_SHA}",
        "./vendor/bin/phpunit"
      ]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "gcr.io/${var.project_id}/app:${COMMIT_REF_NAME}_${COMMIT_SHA}"
      ]
    }

    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        "${var.project_id}-dev-srv",
        "--image",
        "gcr.io/${var.project_id}/app:${COMMIT_REF_NAME}_${COMMIT_SHA}",
        "--region",
        var.region,
        "--platform",
        "managed"
      ]
    }
  }
}

resource "google_project_iam_binding" "cloudbuild_iam_dev" {
  project = var.project_id
  role    = "roles/run.admin"

  members = [
    "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
  ]

  depends_on = [
    google_cloudbuild_trigger.dev
  ]
}

resource "google_project_iam_binding" "cloudbuild_sa_dev" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
  ]

  depends_on = [
    google_cloudbuild_trigger.dev
  ]
}
