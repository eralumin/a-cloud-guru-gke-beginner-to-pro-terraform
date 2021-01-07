resource "kubernetes_deployment" "myapp_blue" {
  metadata {
    name      = "myapp-blue"
    namespace = kubernetes_namespace.blue_green_deployment.metadata.0.name
    labels = {
      app = "myapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app     = "myapp"
        version = "blue"
      }
    }

    template {
      metadata {
        labels = {
          app     = "myapp"
          version = "blue"
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


resource "kubernetes_deployment" "myapp_green" {
  metadata {
    name      = "myapp-green"
    namespace = kubernetes_namespace.blue_green_deployment.metadata.0.name
    labels = {
      app = "myapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app     = "myapp"
        version = "green"
      }
    }

    template {
      metadata {
        labels = {
          app     = "myapp"
          version = "green"
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
