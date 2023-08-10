terraform {
  backend "s3" {
    bucket = "fanc-terraform-backend-stg"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
