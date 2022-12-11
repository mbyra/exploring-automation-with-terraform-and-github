# You can keep here common resources and data


terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  backend "s3" {
    bucket         = "tf-state-mbyra"
    key            = "global/terraform.tfstate"
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

# Route53 zone is shared across staging and production
resource "aws_route53_zone" "primary" {
  name = "marcinbyra.com"
}
