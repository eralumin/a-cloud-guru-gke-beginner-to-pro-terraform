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