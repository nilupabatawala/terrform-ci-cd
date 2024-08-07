output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnets[*].id
  description = "The ID of the VPC"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnets[*].id
  description = "The ID of the VPC"
}