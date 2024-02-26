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

