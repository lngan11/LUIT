#VPC Resource
resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "tf_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "tf_ig" {
  vpc_id = aws_vpc.tf_vpc.id
}

resource "aws_security_group" "tf_sg" {
  name_prefix = var.security_group_name
  vpc_id      = aws_vpc.tf_vpc.id

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

  egress {
    description = "Allow All Outbound"
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "tf_instance" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.tf_key
  vpc_security_group_ids = [aws_security_group.tf_sg.id]
  subnet_id              = aws_subnet.tf_subnet.id
  iam_instance_profile   = var.iam_instance_profile_name
  user_data              = var.user_data

  tags = {
    Name = "terraform-project"
  }
}

#S3 Bucket
resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket        = var.s3_bucket_name
  force_destroy = true

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

resource "aws_iam_role" "ec2_IAM_role" {
  assume_role_policy = var.ec2_trust_policy
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  role = aws_iam_role.ec2_IAM_role.id
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  role   = aws_iam_role.ec2_IAM_role.id
  policy = var.ec2_s3_permissions
}

resource "aws_s3_bucket_acl" "jenkins_artifacts" {
  bucket = aws_s3_bucket.jenkins_artifacts.id

  acl = "private"
}
