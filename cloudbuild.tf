resource "google_cloudbuild_trigger" "default" {
  trigger_template {
    branch_name = var.environment
    repo_name   = var.git_repo
    dir         = "app"
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/${var.project_id}/app:$COMMIT_SHA", "."]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "run",
        "gcr.io/${var.project_id}/app:$COMMIT_SHA",
        "./vendor/bin/phpunit"
      ]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "gcr.io/${var.project_id}/app:$COMMIT_SHA"
      ]
    }

    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        "${var.project_id}-${var.environment}-srv",
        "--image",
        "gcr.io/${var.project_id}/app:$COMMIT_SHA",
        "--region",
        var.region,
        "--platform",
        "managed"
      ]
    }
  }
}

resource "google_project_iam_binding" "cloudbuild_iam" {
  project = var.project_id
  role    = "roles/run.admin"

  members = [
    "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
  ]

  depends_on = [
    google_cloudbuild_trigger.default
  ]
}

resource "google_project_iam_binding" "cloudbuild_sa" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
  ]

  depends_on = [
    google_cloudbuild_trigger.default
  ]
}
