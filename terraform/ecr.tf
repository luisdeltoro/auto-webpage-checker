resource "aws_ecr_repository" "awc-lambda" {
  name                 = "awc-lambda"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}