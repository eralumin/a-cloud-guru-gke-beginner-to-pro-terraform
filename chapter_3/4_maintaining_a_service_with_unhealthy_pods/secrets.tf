resource "kubernetes_secret" "cloudsql_instance_credentials" {
  metadata {
    name = "cloudsql-instance-credentials"
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.cloudsqlproxy_key.private_key)
  }
}
