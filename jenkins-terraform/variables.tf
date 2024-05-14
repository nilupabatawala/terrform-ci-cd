variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
   default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
   default     = []
}


variable "azs" {
  type        = list(string)
  description = "Availability Zones"
    default     = []
}

variable "azs_private" {
  type        = list(string)
  description = "Availability Zones"
    default     = []
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


variable "region" {
  description = "region"
  type        = string
  default     = "eu-north-1"
}

