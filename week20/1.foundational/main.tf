provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip}/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = "my-jenkins-artifacts"
}
#Using the AWS provider to create an EC2 instance, a security group for the instance, and an S3 bucket for Jenkins artifacts. We are also using user_data to bootstrap the EC2 instance with a script that installs and starts Jenkins.

#The security group allows traffic on port 22 only from the user's IP address and allows traffic from port 8080 from any IP address.
