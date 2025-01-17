
# provider "aws" {
#   region = var.region
# }

# # Filter out local zones, which are not currently supported 
# # with managed node groups
# data "aws_availability_zones" "available" {
#   filter {
#     name   = "opt-in-status"
#     values = ["opt-in-not-required"]
#   }
# }

# locals {
#   cluster_name = "Terraform-cluster-${random_string.suffix.result}"
# }

# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.8.1"

#   name = "education-vpc"

#   cidr = "10.0.0.0/16"
#   azs  = slice(data.aws_availability_zones.available.names, 0, 3)

#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.8.5"

#   cluster_name    = local.cluster_name
#   cluster_version = "1.29"

#   cluster_endpoint_public_access           = true
#   enable_cluster_creator_admin_permissions = true

#   cluster_addons = {
#     aws-ebs-csi-driver = {
#       service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#     }
#   }

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   eks_managed_node_group_defaults = {
#     ami_type = "AL2_x86_64"

#   }

#   eks_managed_node_groups = {
#     one = {
#       name = "node-group-1"

#       instance_types = ["t2.medium"]

#       min_size     = 1
#       max_size     = 2
#       desired_size = 1
#     }
#   }
# }


# resource "helm_release" "kube_prometheus_stack" {
#   name             = "kube-prometheus-stack"
#   chart            = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   namespace        = "monitoring"
#   create_namespace = true
#   version          = "67.10.0"

#   # Ensure the Helm release depends on the EKS cluster being created first
# #   depends_on = [
# #     module.eks
# #   ]
# }
# resource "local_file" "kubeconfig" {
#   content  = module.eks.kubeconfig
#   filename = "${path.module}/kubeconfig_eks"
# }
 
# output "kubeconfig" {
#   value      = module.eks.kubeconfig
#   sensitive  = true
# }

# resource "null_resource" "helm_repo_update" {
#   provisioner "local-exec" {
#     command = "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update"
#   }
# }



# provider "aws" {
#   region = var.region
# }

# # Filter out local zones, which are not currently supported 
# # with managed node groups
# data "aws_availability_zones" "available" {
#   filter {
#     name   = "opt-in-status"
#     values = ["opt-in-not-required"]
#   }
# }

# locals {
#   cluster_name = "Terraform-cluster-${random_string.suffix.result}"
# }

# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.8.1"

#   name = "education-vpc"

#   cidr = "10.0.0.0/16"
#   azs  = slice(data.aws_availability_zones.available.names, 0, 3)

#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.8.5"

#   cluster_name    = local.cluster_name
#   cluster_version = "1.29"

#   cluster_endpoint_public_access           = true
#   enable_cluster_creator_admin_permissions = true

#   cluster_addons = {
#     aws-ebs-csi-driver = {
#       service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#     }
#   }

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   eks_managed_node_group_defaults = {
#     ami_type = "AL2_x86_64"
#   }

#   eks_managed_node_groups = {
#     one = {
#       name = "node-group-1"

#       instance_types = ["t2.medium"]

#       min_size     = 1
#       max_size     = 2
#       desired_size = 1
#     }
#   }
# }

# # Add a local-exec provisioner to get the kubeconfig path
# resource "null_resource" "get_kubeconfig" {
#   depends_on = [module.eks]

#   provisioner "local-exec" {
#     command = <<EOT
#       aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name} --kubeconfig ${path.module}/kubeconfig
#     EOT
#   }
# }

# # Output the path of the kubeconfig file
# output "kubeconfig_path" {
#   value = "${path.module}/kubeconfig"
# }

# # Helm release for kube-prometheus-stack
# resource "helm_release" "kube_prometheus_stack" {
#   name             = "kube-prometheus-stack"
#   chart            = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   namespace        = "monitoring"
#   create_namespace = true
#   version          = "67.10.0"

#   # Ensure the Helm release depends on the EKS cluster and kubeconfig path being set
#   depends_on = [
#     null_resource.get_kubeconfig
#   ]

#   set = [
#     {
#       name  = "kubeconfig"
#       value = "${path.module}/kubeconfig"
#     }
#   ]

#   # Set the KUBECONFIG environment variable to ensure Helm can find the kubeconfig file
#   environment = {
#     KUBECONFIG = "${path.module}/kubeconfig"
#   }
# }




# provider "aws" {
#   region = var.region
# }

# data "aws_availability_zones" "available" {
#   filter {
#     name   = "opt-in-status"
#     values = ["opt-in-not-required"]
#   }
# }

# locals {
#   cluster_name = "Terraform-cluster-${random_string.suffix.result}"
# }

# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.8.1"

#   name = "education-vpc"

#   cidr = "10.0.0.0/16"
#   azs  = slice(data.aws_availability_zones.available.names, 0, 3)

#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.8.5"

#   cluster_name    = local.cluster_name
#   cluster_version = "1.29"

#   cluster_endpoint_public_access           = true
#   enable_cluster_creator_admin_permissions = true

#   cluster_addons = {
#     aws-ebs-csi-driver = {
#       service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#     }
#   }

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   eks_managed_node_group_defaults = {
#     ami_type = "AL2_x86_64"
#   }

#   eks_managed_node_groups = {
#     one = {
#       name = "node-group-1"

#       instance_types = ["t2.medium"]

#       min_size     = 1
#       max_size     = 2
#       desired_size = 1
#     }
#   }
# }

# # Add a local-exec provisioner to get the kubeconfig path
# resource "null_resource" "get_kubeconfig" {
#   depends_on = [module.eks]

#   provisioner "local-exec" {
#     command = <<EOT
#       aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name} --kubeconfig ${path.module}/kubeconfig
#     EOT
#   }
# }

# # Output the path of the kubeconfig file
# output "kubeconfig_path" {
#   value = "${path.module}/kubeconfig"
# }

# # Helm release for kube-prometheus-stack
# resource "helm_release" "kube_prometheus_stack" {
#   name             = "kube-prometheus-stack"
#   chart            = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   namespace        = "monitoring"
#   create_namespace = true
#   version          = "67.10.0"

#   depends_on = [
#     null_resource.get_kubeconfig
#   ]

#   set = [
#     {
#       name  = "kubeconfig"
#       value = "${path.module}/kubeconfig"
#     }
#   ]

#   # Use local-exec provisioner to install the Helm chart after kubeconfig is updated
#   provisioner "local-exec" {
#     command = <<EOT
#       export KUBECONFIG=${path.module}/kubeconfig
#       helm upgrade --install kube-prometheus-stack ${path.module}/charts/kube-prometheus-stack
#     EOT
#   }
# }

provider "aws" {
  region = var.region
}

locals {
  cluster_name = "Terraform-cluster-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "education-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}

# Add a local-exec provisioner to get the kubeconfig path
resource "null_resource" "get_kubeconfig" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
      aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name} --kubeconfig ${path.module}/kubeconfig
    EOT
  }
}

# Helm release for kube-prometheus-stack
resource "helm_release" "kube_prometheus_stack" {
  name             = "prometheus-stack"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "monitoring"
  create_namespace = true
  version          = "67.10.0"

  depends_on = [
    null_resource.get_kubeconfig
  ]

  set = [
    {
      name  = "kubeconfig"
      value = "${path.module}/kubeconfig"
    }
  ]

  # Use local-exec provisioner to install the Helm chart after kubeconfig is updated
  provisioner "local-exec" {
    command = <<EOT
      export KUBECONFIG=${path.module}/kubeconfig
      helm upgrade --install kube-prometheus-stack ${path.module}/charts/kube-prometheus-stack
    EOT
  }
}
