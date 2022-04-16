
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "<18"

  cluster_version = var.k8s_version
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  enable_irsa     = true
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  node_groups = {
    coin-eks-workers = {
      create_launch_template = true
      name                   = "karp-eks-managed" 
      instance_types         = ["t3a.medium"]
      capacity_type          = "ON_DEMAND"
      desired_capacity       = 1
      max_capacity           = 1
      min_capacity           = 1
      disk_type              = "gp2"
      disk_size              = 20
      ebs_optimized          = true
      max_unavailable        = 0
      remote_access = {
        ec2_ssh_key = aws_key_pair.ssh_key.id
        
      }
      enable_monitoring      = true

      additional_tags = {
        Name = "eks-stg-managed-nodes"
      }

    }
  }
  
  tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }

}