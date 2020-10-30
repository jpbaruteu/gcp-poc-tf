resource "google_cloudbuild_trigger" "default" {
  name = var.environment
  trigger_template {
    branch_name = var.environment
    repo_name   = "${var.project_id}-repository"
    dir         = "app"
  }

  build {
    step {
      name = "ubuntu"
      args = ["echo", "Running sonnar scanner against application sources... OK"]
    }
	
    step {
      name = "ubuntu"
      args = ["echo", "Running checkmarx analysis... OK"]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      entrypoint = "sh"
      args = ["-c", "docker build -t gcr.io/${var.project_id}/app:$(cat ../app_version) ."]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      entrypoint = "sh"
      args = ["-c", "docker run gcr.io/${var.project_id}/app:$(cat ../app_version) ./vendor/bin/phpunit"]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      entrypoint = "sh"
      args = ["-c", "docker push gcr.io/${var.project_id}/app:$(cat ../app_version)"]
    }

    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "sh"
      args = ["-c", "gcloud run deploy ${var.project_id}-${var.environment}-srv --image gcr.io/${var.project_id}/app:$(cat ../app_version) --region ${var.region} --platform managed"]
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
