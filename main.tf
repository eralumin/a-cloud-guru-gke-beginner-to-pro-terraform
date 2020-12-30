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
  source  = "./chapter_2/2_creating_a_gke_cluster"
  region  = var.region
  project = google_project.project.project_id
}

module "chapter_2_4_creating_pods" {
  source  = "./chapter_2/4_creating_pods"
  region  = var.region
  project = google_project.project.project_id
}

module "chapter_2_6_deployments_and_services" {
  source  = "./chapter_2/6_deployments_and_services"
  region  = var.region2
  project = google_project.project.project_id
}

module "chapter_2_7_monitoring_logging_and_debugging" {
  source  = "./chapter_2/7_monitoring_logging_and_debugging"
  region  = var.region2
  project = google_project.project.project_id
}
