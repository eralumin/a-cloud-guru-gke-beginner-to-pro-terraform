resource "kubernetes_deployment" "zoneprinter" {
  metadata {
    name = "zoneprinter"
    labels = {
      app = "zoneprinter"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "zoneprinter"
      }
    }

    template {
      metadata {
        labels = {
          app = "zoneprinter"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "gcr.io/google-samples/zone-printer:0.1"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "zoneprinter" {
  metadata {
    name = "zoneprinter"
    labels = {
      app = "zoneprinter"
    }
  }

  spec {
    port {
      name      = "http"
      port      = 80
      node_port = 30061
    }

    selector = {
      app = "zoneprinter"
    }

    type = "NodePort"
  }
}
