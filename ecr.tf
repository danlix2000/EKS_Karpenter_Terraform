resource "aws_ecr_repository" "ecr-karp" {
  name                 = "app-dev"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
