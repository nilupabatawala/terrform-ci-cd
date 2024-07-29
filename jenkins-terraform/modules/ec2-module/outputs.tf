output "jenkins_instance_public_ip" {
  description = "Public IP address of the Jenkins instance"
  value       = aws_instance.instance1.public_ip
}

# output "ansible_instance_public_ip" {
#   description = "Public IP address of the Ansible instance"
#   value       = aws_instance.instance2.public_ip
# }