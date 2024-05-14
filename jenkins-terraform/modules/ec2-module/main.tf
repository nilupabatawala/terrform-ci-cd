

#configure aws key pair
resource "aws_key_pair" "tf-key" {
  key_name   = "tf-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# generate private key
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#create local file to store private key
resource "local_file" "foo" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf.key"
}

#configure ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu*"]
  }
}

# allow ssh access
resource "aws_security_group" "allow_ssh" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#configure aws instance
resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_cidrs, 0)
  key_name                    = aws_key_pair.tf-key.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_ssh.id]
  lifecycle {
    ignore_changes = [security_groups]
  }

  user_data = templatefile("${path.module}/jenkins.sh", {})


}

