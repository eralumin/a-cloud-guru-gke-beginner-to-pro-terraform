resource "random_id" "username" {
  byte_length = 14
}

resource "random_id" "password" {
  byte_length = 16
}

resource "google_container_cluster" "primary" {
  name     = "${var.lab_name}-cluster"
  location = var.region

  initial_node_count = 1
  node_config {
    preemptible  = true
    machine_type = "g1-small"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  master_auth {
    username = random_id.username.hex
    password = random_id.password.hex
  }
}

provider "kubernetes" {
  load_config_file = false

  username = google_container_cluster.primary.master_auth[0].username
  password = google_container_cluster.primary.master_auth[0].password
  host     = google_container_cluster.primary.endpoint

  client_certificate     = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_deployment" "myapp" {
  metadata {
    name = "${var.lab_name}-myapp"
    labels = {
      test = "${var.lab_name}-myapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "${var.lab_name}-myapp"
      }
    }

    template {
      metadata {
        labels = {
          test = "${var.lab_name}-myapp"
        }
      }

      spec {
        container {
          image = "gcr.io/${var.project}/myapp"
          name  = "myapp"
        }
      }
    }
  }
}

resource "kubernetes_service" "myapp" {
  metadata {
    name = "${var.lab_name}-myapp-service"
  }
  spec {
    selector = {
      test = "${var.lab_name}-myapp"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8888
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "${var.lab_name}-nginx"
    labels = {
      test = "${var.lab_name}-nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "${var.lab_name}-nginx"
      }
    }

    template {
      metadata {
        labels = {
          test = "${var.lab_name}-nginx"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "${var.lab_name}-nginx-service"
  }
  spec {
    selector = {
      test = "${var.lab_name}-nginx"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
