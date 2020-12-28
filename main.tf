resource "google_project" "project" {
  name            = "A Cloud Guru - GKE"
  project_id      = "${var.uid_prefix}-acg-gke"
  billing_account = var.billing_account
}

resource "google_project_service" "service" {
  for_each = toset(var.services)
  project  = google_project.project.project_id
  service  = each.value
}

module "chapter_2_2_creating_a_gke_cluster" {
  source = "./chapter_2/2_creating_a_gke_cluster"
  region = var.region
}
