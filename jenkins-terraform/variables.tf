variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
   default     = ["192.168.0.0/24"]
}


variable "azs" {
  type        = list(string)
  description = "Availability Zones"
    default     = ["us-east-1a"]
}

variable "ami" {
  description = "EC2 ami"
  type        = string
  default     = ""
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = ""
}


variable "bucket" {
  description = "Remote backend S3 bucket"
  type        = string
  default     = "jenkins-terraform-tf-state"
}

variable "key" {
  description = "key"
  type        = string
  default     = "tf-infra/terraform.tfstate"
}


variable "dynamodb_table" {
  description = "dynamodb table"
  type        = string
  default     = "terraform-state-locking"
}

variable "region" {
  description = "region"
  type        = string
  default     = "eu-north-1"
}

