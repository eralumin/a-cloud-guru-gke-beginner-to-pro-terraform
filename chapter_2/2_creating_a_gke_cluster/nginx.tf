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
