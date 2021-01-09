resource "kubernetes_service" "myapp_blue_service" {
  metadata {
    name = "myapp-blue-service"
  }
  spec {
    selector = {
      app     = "myapp"
      version = "blue"
    }

    port {
      port        = 80
      target_port = 8888
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "myapp_green_service" {
  metadata {
    name = "myapp-green-service"
  }
  spec {
    selector = {
      app     = "myapp"
      version = "green"
    }

    port {
      port        = 80
      target_port = 8888
    }

    type = "ClusterIP"
  }
}
