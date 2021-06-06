terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "ec2_instances" {
  source  = "./modules/ec2-instances"

  instances_count = var.aws_instances_count
  instance_type = var.aws_instance_type
  ami = var.aws_ami
  key_name = var.aws_key_name
}