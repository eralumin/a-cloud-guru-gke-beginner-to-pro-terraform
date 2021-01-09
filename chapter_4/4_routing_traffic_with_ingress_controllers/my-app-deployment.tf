resource "kubernetes_deployment" "myapp_blue" {
  metadata {
    name      = "myapp-blue"
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
          image = "gcr.io/${var.project}/myapp:blue"

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
          image = "gcr.io/${var.project}/myapp:green"

          port {
            container_port = 8888
          }
        }
      }
    }
  }
}
