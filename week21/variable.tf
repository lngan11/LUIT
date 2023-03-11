variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "az_names" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "user_data" {
  default = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
systemctl status httpd
yum install -y firewalld
systemctl start firewalld
systemctl enable firewalld
systemctl status firewalld

# Allow HTTP traffic through firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

sudo cat > /var/www/html/index.html << EOF
<html>
<head>
  <title> Level Up in Tech </title>
</head>
<body>
  <p> Auto Scaling Group made using Terraform
</body>
</html>

EOF
}

