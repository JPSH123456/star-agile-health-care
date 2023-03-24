//Security group creation and whitelisting the ip
resource "aws_security_group" "allow_tls" {
  name = "terraform-sg"

  ingress {
 description = "HTTPS traffic"
 from_port = 443
 to_port = 443
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
 description = "HTTP traffic"
 from_port = 0
 to_port = 65000
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
 description = "SSH port"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 ipv6_cidr_blocks = ["::/0"]
 }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-1"
}
resource "aws_instance" "myec2" {
  ami                    = "ami-0b828c1c5ac3f13ee"
  instance_type          = "t2.micro"
  availability_zone = "ap-northeast-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name = "tokyo"
  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.public_ip} > /etc/ansible/hosts"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "tokyo"
  public_key = "ssh-rsa "AAAAB3NzaC1yc2EAAAADAQABAAABAQCXPfdMfczVO/UfNrE5UV2hfJ+RtMwoFUw154rIdlZb159IzdNjy6DOBJMAoOs2U1u2xUDUqblnNXt60kqQ+IyKjiCtI3HK4CrsVCsV6259egMVdfyj5PKrUb0vWo3PXcN0NQa7gzJMyo3YGj6H6AaKOf24YwOlZmeH+6L9OomF7MeNcLl0xkm8r/6oExkR1ZZFWI3h+nEX8FG3aNRWp5w+nJ5xSjyL8y3hiv0RlC+RnqymKynIn55YOGITjK7Tl/rM2ydThUm1h2hIrBiHj/EXby8yUWRvyFxnALHnsF/nJSxq/lOTbcHXoWyeF3/qFj+lo1LM4Qi026OscdNmMCO9"
}
