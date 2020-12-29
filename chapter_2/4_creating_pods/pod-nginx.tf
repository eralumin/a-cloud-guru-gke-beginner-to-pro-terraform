resource "kubernetes_pod" "nginx" {
  metadata {
    name = "${var.lab_name}-nginx"
  }

  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"

      port {
        name           = "web"
        container_port = 80
      }
    }
  }
}
