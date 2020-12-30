resource "kubernetes_deployment" "redis_slave" {
  metadata {
    name = "redis-slave"
    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app  = "redis"
        role = "slave"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "redis"
          role = "slave"
          tier = "backend"
        }
      }

      spec {
        container {
          name  = "slave"
          image = "gcr.io/google_samples/gb-redisslave:v3"

          port {
            container_port = 6379
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

resource "kubernetes_service" "redis_master" {
  metadata {
    name = "redis-master"
    labels = {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    port {
      port        = 6379
      target_port = "6379"
    }

    selector = {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }
}

resource "kubernetes_service" "redis_slave" {
  metadata {
    name = "redis-slave"
    labels = {
      app  = "redis"
      role = "slave"
      tier = "backend"
    }
  }

  spec {
    port {
      port = 6379
    }

    selector = {
      app  = "redis"
      role = "slave"
      tier = "backend"
    }
  }
}

resource "kubernetes_deployment" "redis_master" {
  metadata {
    name = "redis-master"
    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "redis"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "redis"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          name  = "master"
          image = "k8s.gcr.io/redis:e2e"

          port {
            container_port = 6379
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

