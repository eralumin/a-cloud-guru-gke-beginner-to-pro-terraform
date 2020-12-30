resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app = "guestbook"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app  = "guestbook"
        tier = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "guestbook"
          tier = "frontend"
        }
      }

      spec {
        container {
          name  = "php-redis"
          image = "gcr.io/google-samples/gb-frontend:v4"

          port {
            container_port = 80
          }

          env {
            name  = "GET_HOSTS_FROM"
            value = "dns"
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app  = "guestbook"
      tier = "frontend"
    }
  }

  spec {
    port {
      port = 80
    }

    selector = {
      app  = "guestbook"
      tier = "frontend"
    }

    type = "LoadBalancer"
  }
}
