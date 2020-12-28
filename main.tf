
resource "google_project" "project" {
  name            = "A Cloud Guru - GKE"
  project_id      = "${var.uid_prefix}-acg-gke"
  billing_account = var.billing_account
}
