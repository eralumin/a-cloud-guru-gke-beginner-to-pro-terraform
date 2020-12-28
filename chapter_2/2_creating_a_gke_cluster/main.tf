resource "google_container_cluster" "primary" {
  name     = "${var.lab_name}-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project}"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.lab_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "g1-small"

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

provider "kubernetes" {
  config_context = "gke_${var.project}_${var.region}_${var.lab_name}-cluster"
}

resource "kubernetes_deployment" "myapp" {
  metadata {
    name = "${var.lab_name}-myapp"
    labels = {
      test = "${var.lab_name}-myapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "${var.lab_name}-myapp"
      }
    }

    template {
      metadata {
        labels = {
          test = "${var.lab_name}-myapp"
        }
      }

      spec {
        container {
          image = "gcr.io/${var.project}/myapp"
          name  = "example"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

  }
}
