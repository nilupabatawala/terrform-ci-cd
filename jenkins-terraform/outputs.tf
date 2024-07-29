output "jenkins" {
  value = module.ec2.jenkins_instance_public_ip
}

# output "ansible" {
#     value = "${module.ec2.ansible_instance_public_ip}"
# }