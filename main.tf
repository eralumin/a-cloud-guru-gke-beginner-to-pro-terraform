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

data "google_client_openid_userinfo" "me" {}

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

module "chapter_3_1_stateless_application_example" {
  source  = "./chapter_3/1_stateless_application_example"
  region  = var.region3
  project = google_project.project.project_id
}

module "chapter_3_4_maintaining_a_service_with_unhealthy_pods" {
  source  = "./chapter_3/4_maintaining_a_service_with_unhealthy_pods"
  region  = var.region3
  project = google_project.project.project_id
}

module "chapter_3_6_volumes_and_persistent_storage" {
  source  = "./chapter_3/6_volumes_and_persistent_storage"
  region  = var.region4
  project = google_project.project.project_id
}

module "chapter_3_9_deployment_patterns" {
  source  = "./chapter_3/9_deployment_patterns"
  region  = var.region4
  project = google_project.project.project_id
}

module "chapter_3_11_autoscaling_all_the_things" {
  source  = "./chapter_3/11_autoscaling_all_the_things"
  region  = var.region5
  project = google_project.project.project_id
}

module "chapter_4_4_routing_traffic_with_ingress_controllers" {
  source  = "./chapter_4/4_routing_traffic_with_ingress_controllers"
  region  = var.region5
  project = google_project.project.project_id
  email = data.google_client_openid_userinfo.me.email
}

module "chapter_4_6_global_load_balancing_with_multi_cluster_ingress" {
  source  = "./chapter_4/6_global_load_balancing_with_multi_cluster_ingress"
  zone1  = var.zone
  zone2  = var.zone2
  project = google_project.project.project_id
}

module "chapter_4_11_running_a_stateful_cassandra_database" {
  source  = "./chapter_4/11_running_a_stateful_cassandra_database"
  region  = var.region6
}
