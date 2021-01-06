resource "kubernetes_secret" "mysql" {
  metadata {
    name = "mysql"
  }

  data = {
    password = "mypassword"
  }
}