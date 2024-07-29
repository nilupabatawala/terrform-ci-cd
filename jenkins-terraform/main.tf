terraform {
    backend "s3" {
    bucket = "jenkins-terraform-tf-state"
    key = "tf-ec2/terraform.tfstate"
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

module "network" {
  source = "./modules/network-module"
  cidr = var.cidr
  public_subnet_cidrs= var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs = var.azs
  azs_private = var.azs_private
 
}

module "ec2" {
  source = "./modules/ec2-module"
  vpc_id = module.network.vpc_id
  public_subnet_cidrs= module.network.public_subnet_ids
  azs = var.azs
  ami = var.ami
  instance_type = var.instance_type
  
}

 module "eks" {
   source = "./modules/eks-module"
   private_subnet_cidrs = module.network.private_subnet_ids
 }