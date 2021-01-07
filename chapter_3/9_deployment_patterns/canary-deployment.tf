resource "kubernetes_deployment" "myapp_prod" {
  metadata {
    name      = "myapp-prod"
    namespace = kubernetes_namespace.canary_deployment.metadata.0.name
    labels = {
      app = "myapp"
    }
  }

  spec {
    replicas = 3

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
          image = "gcr.io/${var.project}/myapp:v1"

          port {
            container_port = 8888
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "myapp_canary" {
  metadata {
    name      = "myapp-canary"
    namespace = kubernetes_namespace.canary_deployment.metadata.0.name
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
          image = "gcr.io/${var.project}/myapp:v2"

          port {
            container_port = 8888
          }
        }
      }
    }
  }
}
