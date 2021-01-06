resource "google_service_account" "cloudsqlproxy_sa" {
  account_id = "${var.lab_name}-cloudsqlproxy"
}

resource "google_project_iam_binding" "project" {
  role    = "roles/cloudsql.client"

  members = [
    "serviceAccount:${google_service_account.cloudsqlproxy_sa.email}",
  ]
}

resource "google_service_account_key" "cloudsqlproxy_key" {
  service_account_id = google_service_account.cloudsqlproxy_sa.name
}
