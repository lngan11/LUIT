variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "subnet cidr"
  type        = string
  default     = "10.0.1.0/24"
}

variable "security_group_name" {
  type    = string
  default = "tf-sg-"
}

variable "instance_ami" {
  type    = string
  default = "ami-0dfcb1ef8550277af"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "tf_key" {
  type    = string
  default = "tf_key"
}

variable "iam_instance_profile_name" {
  description = "IAM role made via AWS console"
  type        = string
  default     = "Terraform-EC2-S3-FullAccess"
}

variable "user_data" {
  type    = string
  default = <<EOF
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


variable "s3_bucket_name" {
  default = "my-jenkins-artifacts"
}

variable "ec2_s3_permissions" {
  description = "IAM permissions for EC2 to S3"
  type        = string
  default     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

variable "ec2_trust_policy" {
  description = "sts assume role policy for EC2"
  type        = string
  default     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }   
    ]
}
EOF  
}