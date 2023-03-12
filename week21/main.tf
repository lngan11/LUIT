# Set AWS provider details
provider "aws" {
  region = "us-east-1"
}

#AWS Availability Zones
data "aws_availability_zones" "available" {}

# Create a VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "custom-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom-vpc-igw"
  }
}

resource "aws_eip" "elastic_ip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

#Create nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id     = aws_eip.elastic_ip.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnet_1.id
}


# Create Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "custom-vpc-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "custom-vpc-public-subnet-2"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "custom-vpc-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "custom-vpc-private-subnet-2"
  }
}

# Create a Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "custom-vpc-public-route-table"
  }
}

# Create a Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "public_rt_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rt_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_rt_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_rt_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Security Group Resources
resource "aws_security_group" "alb_security_group" {
  description = "ALB Security Group"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#Auto Scaling Group
resource "aws_security_group" "asg_security_group" {
  name   = "asg-security-group"
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "asg security group"
  }
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_autoscaling_group" "asg" {
  name                      = "asg"
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 4
  health_check_grace_period = 120
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.target_group.arn]
  termination_policies      = ["OldestInstance"]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version

  }
}


#Launch Template
resource "aws_launch_template" "launch_template" {
  name          = "launch_template"
  image_id      = "ami-006dcf34c09e50022"
  instance_type = "t2.micro"
  user_data     = base64encode(var.user_data)

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg_security_group.id]

  }
}
#Application Load Balancer

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

resource "aws_lb_target_group" "target_group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
