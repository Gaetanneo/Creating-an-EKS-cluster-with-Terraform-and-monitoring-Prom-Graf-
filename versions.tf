terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "my-eks-bucket-12-09-2024"
    region         = "us-east-1"
    key            = "eks/terraform.tfstate"
    dynamodb_table = "EKS-db-Lock-Files"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5"
    }
  }
}
