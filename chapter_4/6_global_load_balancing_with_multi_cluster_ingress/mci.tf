resource "google_compute_global_address" "kubemci_ip" {
  name = "kubemci-ip"
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig-template.yaml")

  vars = {
    first_user_name       = google_container_cluster.first.master_auth[0].username
    first_user_password   = google_container_cluster.first.master_auth[0].password
    first_cluster_name    = google_container_cluster.first.name
    first_endpoint        = google_container_cluster.first.endpoint
    first_client_cert     = google_container_cluster.first.master_auth[0].client_certificate
    first_client_cert_key = google_container_cluster.first.master_auth[0].client_key
    first_cluster_ca      = google_container_cluster.first.master_auth[0].cluster_ca_certificate

    second_user_name       = google_container_cluster.second.master_auth[0].username
    second_user_password   = google_container_cluster.second.master_auth[0].password
    second_cluster_name    = google_container_cluster.second.name
    second_endpoint        = google_container_cluster.second.endpoint
    second_client_cert     = google_container_cluster.second.master_auth[0].client_certificate
    second_client_cert_key = google_container_cluster.second.master_auth[0].client_key
    second_cluster_ca      = google_container_cluster.second.master_auth[0].cluster_ca_certificate
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = "${path.module}/kubeconfig"
}

resource "null_resource" "setup_kubemci" {
  provisioner "local-exec" {
    command = "./kubemci create zone-printer --ingress=${path.module}/manifests/ingress.yaml --kubeconfig=${local_file.kubeconfig.filename}"
  }
}
