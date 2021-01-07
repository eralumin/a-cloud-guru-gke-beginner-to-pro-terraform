resource "random_id" "username" {
  byte_length = 14
}

resource "random_id" "password" {
  byte_length = 16
}

resource "google_container_cluster" "primary" {
  name     = "${var.lab_name}-cluster"
  location = var.region

  initial_node_count = 1
  node_config {
    preemptible  = true
    machine_type = "g1-small"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      maximum       = 3
    }
    resource_limits {
      resource_type = "memory"
      maximum       = 5
    }
  }

  master_auth {
    username = random_id.username.hex
    password = random_id.password.hex
  }
}

provider "kubernetes" {
  load_config_file = false

  username = google_container_cluster.primary.master_auth[0].username
  password = google_container_cluster.primary.master_auth[0].password
  host     = google_container_cluster.primary.endpoint

  client_certificate     = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "blue_green_deployment" {
  metadata {
    name = "blue-green-deployment"
  }
}

resource "kubernetes_namespace" "canary_deployment" {
  metadata {
    name = "canary-deployment"
  }
}
