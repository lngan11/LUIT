variable "region" {
  description = "The AWS region to deploy resources in."
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the EC2 key pair to use for SSH access."
}

variable "allowed_ip" {
  description = "The IP address to allow SSH traffic from."
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create for Jenkins artifacts."
}
