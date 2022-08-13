provider "aws" {
  region = "us-east-2"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    } 
  }
  # using terraform cloud as backend   
  backend "remote" {
    #          The name of your Terraform Cloud organization.
    organization = "paretos"
    #
    #         # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "prod"
    }
  }
}

module "eks" {
  source      = "../terraform/module/eks/"
  db_username = var.db_username
  db_password = var.db_password
  az-a        = "us-east-2a"
  az-b        = "us-east-2b"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

output "postgresdns" {
  value     = module.eks.dns
  sensitive = true
}
