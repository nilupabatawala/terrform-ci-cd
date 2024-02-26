terraform {
    backend "s3" {
    bucket = "jenkins-terraform-tf-state"
    key = "tf-infra/terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

}


module "ec2" {
  source = "./modules/ec2-module"
  cidr = var.cidr
  public_subnet_cidrs= var.public_subnet_cidrs
  azs = var.azs
  ami = var.ami
  instance_type = var.instance_type
}