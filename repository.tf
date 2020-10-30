resource "google_sourcerepo_repository" "default" {
  name = "${var.project_id}-repository"

  depends_on = [
    google_project_service.sourcerepo,
  ]
}

resource "google_sourcerepo_repository" "TF" {
  name = "${var.project_id}-repository-TF"

  depends_on = [
    google_project_service.sourcerepo,
  ]
}
