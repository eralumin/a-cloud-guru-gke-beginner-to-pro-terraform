resource "random_id" "first_username" {
  byte_length = 14
}

resource "random_id" "first_password" {
  byte_length = 16
}

resource "random_id" "second_username" {
  byte_length = 14
}

resource "random_id" "second_password" {
  byte_length = 16
}

resource "google_container_cluster" "first" {
  name     = "${var.lab_name}-first"
  location = var.zone1

  initial_node_count = 1
  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  master_auth {
    username = random_id.first_username.hex
    password = random_id.first_password.hex

    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_cluster" "second" {
  name     = "${var.lab_name}-second"
  location = var.zone2

  initial_node_count = 1
  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  master_auth {
    username = random_id.second_username.hex
    password = random_id.second_password.hex

    client_certificate_config {
      issue_client_certificate = true
    }

  }
}

provider "kubernetes" {
  alias            = "first"
  load_config_file = false

  username = google_container_cluster.first.master_auth[0].username
  password = google_container_cluster.first.master_auth[0].password
  host     = google_container_cluster.first.endpoint

  client_certificate     = base64decode(google_container_cluster.first.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.first.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.first.master_auth[0].cluster_ca_certificate)
}

provider "kubernetes" {
  alias            = "second"
  load_config_file = false

  username = google_container_cluster.second.master_auth[0].username
  password = google_container_cluster.second.master_auth[0].password
  host     = google_container_cluster.second.endpoint

  client_certificate     = base64decode(google_container_cluster.second.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.second.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.second.master_auth[0].cluster_ca_certificate)
}

module "first_cluster_resources" {
  source = "./resources_for_each_cluster"
  providers = {
    kubernetes = kubernetes.first
  }

  username = google_container_cluster.first.master_auth[0].username
}

module "second_cluster_resources" {
  source = "./resources_for_each_cluster"
  providers = {
    kubernetes = kubernetes.second
  }

  username = google_container_cluster.second.master_auth[0].username

}
