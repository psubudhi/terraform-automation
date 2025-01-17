# # provider "kubernetes" {
# #   host                   = module.eks.cluster_endpoint
# #   token                  = data.aws_eks_cluster_auth.eks.token
# #   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
# # }

# # data "aws_eks_cluster_auth" "eks" {
# #   name = module.eks.cluster_name
# # }

# # provider "helm" {
# #     config_path = "~/.kube/config"
# # }

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   token                  = data.aws_eks_cluster_auth.eks.token
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.cluster_name
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     token                  = data.aws_eks_cluster_auth.eks.token
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   }
# }
