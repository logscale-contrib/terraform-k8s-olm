data "http" "crds" {
  url = "https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/master/deploy/upstream/quickstart/crds.yaml"

}
data "kubectl_file_documents" "crds" {
  content = data.http.crds.response_body
}

data "http" "deploy" {
  url = "https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/master/deploy/upstream/quickstart/olm.yaml"

}
data "kubectl_file_documents" "deploy" {
  content = data.http.deploy.response_body
}

resource "kubectl_manifest" "crds" {
  server_side_apply = true
  for_each          = data.kubectl_file_documents.crds.manifests
  yaml_body         = each.value
}
resource "kubectl_manifest" "deploy" {
    depends_on = [
      kubectl_manifest.crds
    ]
  server_side_apply = true
  for_each          = data.kubectl_file_documents.deploy.manifests
  yaml_body         = each.value
}