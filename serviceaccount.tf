resource "google_service_account" "cloudrun_service_account" {
  account_id   = "cloudrun"
  display_name = "Cloud Run"
}

resource "google_project_iam_member" "cloudrun_iam_sqlclient" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun_service_account.email}"
}

resource "google_service_account_iam_binding" "cloudrun_iam_binding_user" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.project_number}-compute@developer.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.cloudrun_service_account.email}",
  ]
}
