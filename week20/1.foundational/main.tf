provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "tf_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "tf_sg" {
  name_prefix = "tf-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.tf_vpc.id
}

resource "aws_instance" "tf_instance" {
  ami           = "ami-0dfcb1ef8550277af"
  instance_type = "t2.micro"
  key_name      = "tf_key"
  associate_public_ip_address = true 
  vpc_security_group_ids = [aws_security_group.tf_sg.id]
  subnet_id     = aws_subnet.tf_subnet.id
  iam_instance_profile = "Terraform-EC2-S3-FullAccess"

  tags = {
    Name = "terraform-project"
  }

  user_data = <<EOF
  #!/bin/bash
# Install Jenkins and Java 
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
# Add required dependencies for the jenkins package
sudo amazon-linux-extras install -y java-openjdk11 
sudo yum install -y jenkins
sudo systemctl daemon-reload

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

              EOF
}

resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = "my-jenkins-artifacts"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_acl" "jenkins_artifacts" {
  bucket = aws_s3_bucket.jenkins_artifacts.id

  acl = "private"
}

