provider "aws" {
  region = var.aws_region
}

locals {
  s3_website_origin = "http://${var.s3_bucket_website}.s3-website-${var.aws_region}.amazonaws.com"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}