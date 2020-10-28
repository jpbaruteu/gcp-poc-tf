resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
}
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}
resource "google_project_service" "sourcerepo" {
  service = "sourcerepo.googleapis.com"
}
