# resource "kubernetes_deployment" "broken-app" {
#   metadata {
#     name = "${var.lab_name}-broken-app"
#     labels = {
#       test = "${var.lab_name}-broken-app"
#     }
#   }

#   spec {
#     replicas = 3

#     selector {
#       match_labels = {
#         test = "${var.lab_name}-broken-app"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           test = "${var.lab_name}-broken-app"
#         }
#       }

#       spec {
#         container {
#           image = "gcr.io/${var.project}/myapp:broken"
#           name  = "broken-app"
#         }
#       }
#     }
#   }
# }
