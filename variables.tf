variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "karp-stg-eks"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
  
}

variable "k8s_version" {
  type    = number
  default = "1.22"

}
