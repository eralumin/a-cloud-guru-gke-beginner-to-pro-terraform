resource "google_container_cluster" "primary" {
  name     = "${var.lab_name}-cluster"
  location = var.region

  initial_node_count = 1

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project}"
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
          name  = "myapp"

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

resource "kubernetes_service" "myapp" {
  metadata {
    name = "${var.lab_name}-myapp-service"
  }
  spec {
    selector = {
      test = "${var.lab_name}-myapp"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8888
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "${var.lab_name}-nginx"
    labels = {
      test = "${var.lab_name}-nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "${var.lab_name}-nginx"
      }
    }

    template {
      metadata {
        labels = {
          test = "${var.lab_name}-nginx"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"

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

resource "kubernetes_service" "nginx" {
  metadata {
    name = "${var.lab_name}-nginx-service"
  }
  spec {
    selector = {
      test = "${var.lab_name}-nginx"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
