resource "kubernetes_service" "canary_deployment_service" {
  metadata {
    name      = "myapp-service"
    namespace = kubernetes_namespace.canary_deployment.metadata.0.name
  }
  spec {
    selector = {
      app     = "myapp"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8888
    }

    type = "LoadBalancer"
  }
}
