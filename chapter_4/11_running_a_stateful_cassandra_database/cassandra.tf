resource "kubernetes_stateful_set" "cassandra" {
  depends_on = [kubectl_manifest.ceph_class]

  metadata {
    name = "cassandra"
    labels = {
      app = "cassandra"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "cassandra"
      }
    }

    template {
      metadata {
        labels = {
          app = "cassandra"
        }
      }

      spec {
        container {
          name  = "cassandra"
          image = "gcr.io/google-samples/cassandra:v13"

          port {
            name           = "intra-node"
            container_port = 7000
          }

          port {
            name           = "tls-intra-node"
            container_port = 7001
          }

          port {
            name           = "jmx"
            container_port = 7199
          }

          port {
            name           = "cql"
            container_port = 9042
          }

          env {
            name  = "MAX_HEAP_SIZE"
            value = "512M"
          }

          env {
            name  = "HEAP_NEWSIZE"
            value = "100M"
          }

          env {
            name  = "CASSANDRA_SEEDS"
            value = "cassandra-0.cassandra.default.svc.cluster.local"
          }

          env {
            name  = "CASSANDRA_CLUSTER_NAME"
            value = "K8Demo"
          }

          env {
            name  = "CASSANDRA_DC"
            value = "DC1-K8Demo"
          }

          env {
            name  = "CASSANDRA_RACK"
            value = "Rack1-K8Demo"
          }

          env {
            name = "POD_IP"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          resources {
            limits {
              cpu    = "500m"
              memory = "1Gi"
            }

            requests {
              cpu    = "500m"
              memory = "1Gi"
            }
          }

          volume_mount {
            name       = "cassandra-data"
            mount_path = "/cassandra_data"
          }

          readiness_probe {
            exec {
              command = ["/bin/bash", "-c", "/ready-probe.sh"]
            }

            initial_delay_seconds = 15
            timeout_seconds       = 5
          }

          lifecycle {
            pre_stop {
              exec {
                command = ["/bin/sh", "-c", "nodetool drain"]
              }
            }
          }

          image_pull_policy = "Always"

          security_context {
            capabilities {
              add = ["IPC_LOCK"]
            }
          }
        }

        termination_grace_period_seconds = 1800
      }
    }

    volume_claim_template {
      metadata {
        name = "cassandra-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }

        storage_class_name = "rook-ceph-block"
      }
    }

    service_name = "cassandra"
  }
}

resource "kubernetes_service" "cassandra" {
  metadata {
    name = "cassandra"
    labels = {
      app = "cassandra"
    }
  }

  spec {
    port {
      port = 9042
    }

    selector = {
      app = "cassandra"
    }

    cluster_ip = "None"
  }
}

