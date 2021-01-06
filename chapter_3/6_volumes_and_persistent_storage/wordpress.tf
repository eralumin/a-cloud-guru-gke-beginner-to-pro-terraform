resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"

    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        volume {
          name = "wordpress-persistent-storage"

          persistent_volume_claim {
            claim_name = "wordpress-volumeclaim"
          }
        }

        container {
          name  = "wordpress"
          image = "wordpress"

          port {
            name           = "wordpress"
            container_port = 80
          }

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "mysql:3306"
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "wordpress-persistent-storage"
            mount_path = "/var/www/html"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "wordpress_volumeclaim" {
  metadata {
    name = "wordpress-volumeclaim"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "200Gi"
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"

    labels = {
      app = "wordpress"
    }
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }

    selector = {
      app = "wordpress"
    }

    type = "LoadBalancer"
  }
}
