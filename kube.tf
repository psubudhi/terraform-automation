provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.EKS_cluster_endpoint
#    token                  = data.terraform_remote_state.eks.outputs.EKS_cluster_auth_token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.EKS_cluster_CA_data)
    config_path = "~/.kube/config"
  # load_config_file       = false
  }
}
 
provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.EKS_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.EKS_cluster_CA_data)
  config_path = "~/.kube/config"
# load_config_file       = false
}