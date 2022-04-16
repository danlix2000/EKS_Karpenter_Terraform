output "endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr-repo" {
  value = aws_ecr_repository.ecr-karp.id

}

output "eks_name" {
  value = var.cluster_name
  
}

output "eks_version" {
  value = var.k8s_version
  
}