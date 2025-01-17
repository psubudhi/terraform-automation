# provider "helm" {
#   kubernetes = {
#     config_path = "${path.module}/kubeconfig"
#   }

  
# }

# provider "kubernetes" {
#   alias = "secondary"
#   host                   = data.terraform_remote_state.eks.outputs.EKS_cluster_endpoint
#   cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.EKS_cluster_CA_data)
#   config_path            = "${path.module}/kubeconfig"
# }
