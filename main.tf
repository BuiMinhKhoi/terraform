# Terraform config
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "bmk-tf-backend"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
  experiments      = [module_variable_optional_attrs]
  required_version = ">= 1.2.0"
}
# Provider
provider "aws" {
  region = "ap-southeast-1"
}
# Infrastructure
#   VPC
module "vpc" {
  source = "./modules/vpc"
  # VPC
  vpc = var.vpc-config
  # SUBNET
  #   PRIVATE
  private-subnet = var.private-subnet
  # SECURITY GROUP
  security-group = var.security-group
}
#   EC2
module "ec2" {
  source = "./modules/ec2"
  ec2-configuration-required = {
    vpc_security_group_ids = ["${module.vpc.security-group-id}"]
    vpc_subnet_id         = "${module.vpc.private-subnet-id}"
  }
  ec2-configuration-optional = var.ec2-configuration-optional
}



