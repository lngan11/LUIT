provider "aws" {
  region = var.region
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [
    aws_security_group.jenkins.name,
  ]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-1.8.0
              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install -y jenkins
              sudo systemctl start jenkins
              EOF
}

resource "aws_security_group" "jenkins" {
  name_prefix = "jenkins-sg-"

  ingress {
    from_port  
