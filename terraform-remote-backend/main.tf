terraform {
  backend "s3" {
    bucket = "jenkins-terraform-tf-state"
    key = "tf-infra/terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
    lock_timeout   = "5m"
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

}

provider "aws" {
  region = var.region
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform-tf-state" {
  bucket        = var.bucket
  force_destroy = true
}


resource "aws_s3_bucket_versioning" "terraform-tf-state-versioning" {
  bucket = aws_s3_bucket.terraform-tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-tf-state-encry" {
  bucket = aws_s3_bucket.terraform-tf-state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}