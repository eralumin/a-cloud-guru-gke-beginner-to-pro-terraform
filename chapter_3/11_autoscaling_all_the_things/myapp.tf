resource "kubernetes_deployment" "myapp" {
  metadata {
    name = "myapp"
    labels = {
      app = "myapp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "myapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "myapp"
        }
      }

      spec {
        container {
          name  = "myapp"
          image = "gcr.io/${var.project}/myapp:blue"

          port {
            container_port = 8888
          }

          resources {
            requests {
              cpu = "200m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "myapp_hpa" {
  metadata {
    name = "myapp-hpa"
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = "myapp"
      api_version = "apps/v1"
    }

    min_replicas                      = 1
    max_replicas                      = 20
    target_cpu_utilization_percentage = 60
  }
}

resource "kubernetes_service" "myapp_service" {
  metadata {
    name = "myapp-service"
  }
  spec {
    selector = {
      app = "myapp"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8888
    }

    type = "LoadBalancer"
  }
}
