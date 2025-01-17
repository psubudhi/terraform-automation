variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Kubernetes Cluster Name"
  type        = string
  default     = "Terraform-cluster-${random_string.suffix.result}"
}