terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  
  backend "s3" {
    bucket       = "tfstate-739275460055-apse2"
    key          = "terraform-test/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "test" {
  bucket = "tf-test-${random_id.suffix.hex}"

  tags = {
    Project   = "terraform-test"
    ManagedBy = "terraform"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.test.bucket
}
