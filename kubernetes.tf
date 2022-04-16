data "aws_eks_cluster" "eks" {

  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {

  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
  }
  
}


resource "local_sensitive_file" "kubeconfig" {
  content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = var.cluster_name,
    clusterca    = data.aws_eks_cluster.eks.certificate_authority[0].data,
    endpoint     = data.aws_eks_cluster.eks.endpoint,
  })
  filename = "./kubeconfig-${var.cluster_name}"
     depends_on = [
       module.eks
  ]
}

