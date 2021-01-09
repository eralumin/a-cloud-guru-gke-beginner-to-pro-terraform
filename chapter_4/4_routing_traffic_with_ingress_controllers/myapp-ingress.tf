resource "kubernetes_ingress" "myapp_ingress" {
  depends_on = [ helm_release.nginx_ingress ]
  metadata {
    name = "myapp-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
    }
  }

  spec {
    rule {
      host = "myapp.example.com"
      http {
        path {
          path = "/blue"
          backend {
            service_name = "myapp-blue-service"
            service_port = "80"
          }
        }

        path {
          path = "/green"
          backend {
            service_name = "myapp-green-service"
            service_port = "80"
          }
        }
      }
    }
  }
}
