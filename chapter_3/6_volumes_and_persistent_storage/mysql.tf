resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"

    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        volume {
          name = "mysql-persistent-storage"

          persistent_volume_claim {
            claim_name = "mysql-volumeclaim"
          }
        }

        container {
          name  = "mysql"
          image = "mysql:5.6"

          port {
            name           = "mysql"
            container_port = 3306
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mysql_volumeclaim" {
  metadata {
    name = "mysql-volumeclaim"
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

resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql"

    labels = {
      app = "mysql"
    }
  }

  spec {
    port {
      port = 3306
    }

    selector = {
      app = "mysql"
    }

    type = "ClusterIP"
  }
}
