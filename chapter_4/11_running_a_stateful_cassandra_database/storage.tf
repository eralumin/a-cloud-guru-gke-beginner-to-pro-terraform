data "kubectl_file_documents" "rook_ceph_common" {
  content = file("${path.module}/rook-ceph/common.yaml")
}

resource "kubectl_manifest" "rook_ceph_common" {
  count     = length(data.kubectl_file_documents.rook_ceph_common.documents)
  yaml_body = element(data.kubectl_file_documents.rook_ceph_common.documents, count.index)
}

resource "kubectl_manifest" "rook_ceph_operator" {
  depends_on = [kubectl_manifest.rook_ceph_common]
  yaml_body  = file("${path.module}/rook-ceph/operator.yaml")
}

data "kubectl_file_documents" "ceph_class" {
  content = file("${path.module}/rook-ceph/ceph-class.yaml")
}

resource "kubectl_manifest" "ceph_class" {
  depends_on = [
    kubectl_manifest.rook_ceph_common,
    kubectl_manifest.rook_ceph_operator
  ]
  count     = length(data.kubectl_file_documents.ceph_class.documents)
  yaml_body = element(data.kubectl_file_documents.ceph_class.documents, count.index)
}

resource "kubectl_manifest" "ceph_cluster" {
  depends_on = [
    kubectl_manifest.rook_ceph_common,
    kubectl_manifest.rook_ceph_operator
  ]
  yaml_body = file("${path.module}/rook-ceph/ceph-cluster.yaml")
}
