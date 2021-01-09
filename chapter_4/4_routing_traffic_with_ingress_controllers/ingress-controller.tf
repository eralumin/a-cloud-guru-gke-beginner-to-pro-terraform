# For more information about setup on GKE see url below:
# https://kubernetes.github.io/ingress-nginx/deploy/#gce-gke

resource "kubernetes_cluster_role_binding" "cluster_admin_binding" {
  metadata {
    name = "cluster-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = var.email
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "helm_release" "nginx_ingress" {
  depends_on = [ kubernetes_cluster_role_binding.cluster_admin_binding ]
  name       = "myingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "3.19.0"
}