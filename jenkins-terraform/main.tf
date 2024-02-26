module "ec2" {
  source = "./modules/ec2-module"
  cidr = var.cidr
  public_subnet_cidrs= var.public_subnet_cidrs
  azs = var.azs
  ami = var.ami
  instance_type = var.instance_type
}