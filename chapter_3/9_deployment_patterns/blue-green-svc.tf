resource "kubernetes_service" "blue_green_deployment_service" {
  metadata {
    name      = "myapp-service"
    namespace = kubernetes_namespace.blue_green_deployment.metadata.0.name
  }
  spec {
    selector = {
      app     = "myapp"
      version = "blue"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8888
    }

    type = "LoadBalancer"
  }
}
