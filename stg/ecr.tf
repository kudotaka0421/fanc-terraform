resource "aws_ecr_repository" "fanc_app_stg" {
  name                 = "fanc-app-stg"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}
