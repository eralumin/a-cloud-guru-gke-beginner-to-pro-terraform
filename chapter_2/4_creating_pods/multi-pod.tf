resource "kubernetes_pod" "multi" {
  metadata {
    name = "${var.lab_name}-multi"
  }

  spec {
    container {
      name  = "web-container"
      image = "nginx:latest"

      volume_mount {
        name       = "shared-data"
        mount_path = "/usr/share/nginx/html"
      }
    }

    container {
      name  = "ftp-container"
      image = "fauria/vsftpd:latest"

      volume_mount {
        name       = "shared-data"
        mount_path = "/pod-data"
      }

      env {
        name  = "FTP_USER"
        value = "admin"
      }
      env {
        name  = "FTP_PASS"
        value = "password"
      }
    }

    volume {
      name = "shared-data"
      empty_dir {}
    }


  }
}
