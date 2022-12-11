# You can initialize S3 and DynamoDB yourself via AWS Console/CLI or use
# the instruction below.
#
# To autoconfigure S3 backend with terraform:
# 1. init terraform in s3_backend directory
# 2. make sure the terraform {} block here is commented out
# 3. set your bucket and DynamoDB table names below
# 4. terraform apply 
# 5. uncomment terraform {} block below, remembering to paste your names
#    (optional - you can keep using standard local backend for these resources)
#    and then terraform init to re-initialize backend
# 7. use your remote s3 backend! 
# Now, in other directories you only need to uncomment terraform {} block.


# terraform {
#   backend "s3" {
#     bucket         = "tf-state-mbyra"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-locking"
#     encrypt        = true
#   }

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "tf-state-mbyra"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}