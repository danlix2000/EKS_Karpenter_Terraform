terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
  }
   backend "remote" {}
}

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.region
}


data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
  role       = module.eks.worker_iam_role_name
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${var.cluster_name}"
  role = module.eks.worker_iam_role_name
}