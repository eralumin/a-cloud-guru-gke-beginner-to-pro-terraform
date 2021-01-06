# resource "kubernetes_deployment" "myapp_isnotready" {
#   metadata {
#     name = "${var.lab_name}-myapp-isnotready"
#     labels = {
#       app = "${var.lab_name}-myapp-isnotready"
#     }
#   }

#   spec {
#     replicas = 1
#     progress_deadline_seconds = 120

#     selector {
#       match_labels = {
#         app = "${var.lab_name}-myapp-isnotready"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "${var.lab_name}-myapp-isnotready"
#         }
#       }

#       spec {
#         container {
#           image = "gcr.io/${var.project}/myapp:probes-error"
#           name  = "myapp-isnotready"
#           liveness_probe {
#             http_get {
#               path = "/isalive"
#               port = 8888
#             }
#             initial_delay_seconds = 3
#             period_seconds        = 3
#           }
#           readiness_probe {
#             http_get {
#               path = "/isready"
#               port = 8888
#             }
#             initial_delay_seconds = 5
#             period_seconds        = 5
#           }
#         }
#         container {
#           image = "gcr.io/cloudsql-docker/gce-proxy:1.11"
#           name  = "cloudsql-proxy"
#           command = [
#             "/cloud_sql_proxy",
#             "--instances=${var.project}:${var.region}:${google_sql_database_instance.master.name}=tcp:3306",
#             "--credential_file=/secrets/cloudsql/credentials.json",
#           ]
#           security_context {
#             run_as_user                = 2
#             allow_privilege_escalation = false
#           }
#           volume_mount {
#             name       = "cloudsql-instance-credentials"
#             mount_path = "/secrets/cloudsql"
#             read_only  = true
#           }
#         }
#         volume {
#           name = "cloudsql-instance-credentials"
#           secret {
#             secret_name = "cloudsql-instance-credentials"
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "myapp_isnotready" {
#   metadata {
#     name = "${var.lab_name}-myapp-isnotready-service"
#   }
#   spec {
#     selector = {
#       app = "${var.lab_name}-myapp-isnotready"
#     }
#     session_affinity = "ClientIP"
#     port {
#       port        = 80
#       target_port = 8888
#     }

#     type = "LoadBalancer"
#   }
# }
