provider "google" {
    project = "${var.uid_prefix}-acg-gke"
    region = var.region
    zone = var.zone
}
