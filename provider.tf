# terraform {
#    required_providers {
#       aws =  {
#           source = "hashicorp/aws"
#           version = "5.84.0"
#       }
#    }
# }

# provider "aws" {
#    #Configuration options
#    region = "us-east-1"
# }

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
  }
  backend "s3" {
    bucket = "laxman-tf-remote-state-dev"
    key = "expense-dev-jenkins"
    region = "us-east-1"
    dynamodb_table = "laxman-tf-remote-state-dev"

  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}