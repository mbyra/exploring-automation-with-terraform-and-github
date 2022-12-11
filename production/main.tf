terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  backend "s3" {
    bucket         = "tf-state-mbyra"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "db_pass" {
  description = "password for database"
  type        = string
  sensitive   = true
  default     = "foobar12" # JUST FOR EASIER TESTING! In real life use e.g. a secret store
}

locals {
  environment_name = "production"
}

module "web_app" {
  source = "../web-app-module"

  # Input Variables
  bucket_name      = "marcin-123456-web-app-data-${local.environment_name}"
  domain           = "marcinbyra.com"
  environment_name = local.environment_name
  instance_type    = "t2.nano"
  create_dns_zone  = false
  db_name          = "${local.environment_name}mydb"
  db_user          = "foo"
  db_pass          = var.db_pass
}
