terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.0.0-pre1"
    }

    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
  }
}

