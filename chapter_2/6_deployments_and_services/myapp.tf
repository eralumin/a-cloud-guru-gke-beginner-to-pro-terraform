resource "kubernetes_deployment" "myapp" {
  metadata {
    name = "${var.lab_name}-myapp"
    labels = {
      app = "${var.lab_name}-myapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "${var.lab_name}-myapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.lab_name}-myapp"
        }
      }

      spec {
        container {
          image = "gcr.io/${var.project}/myapp:bad"
          name  = "myapp"
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
      app = "${var.lab_name}-myapp"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8888
    }

    type = "LoadBalancer"
  }
}