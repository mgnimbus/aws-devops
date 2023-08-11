data "aws_vpc" "vpc" {
  id = "vpc-0aa0cdbe4c44c04a3"
}


data "aws_subnet" "subnet" {
  id = "subnet-0e4c190e74b5852b0"
}

data "aws_subnet" "subnet1" {
  id = "subnet-0951560b18ee56a76"
}



resource "aws_security_group" "alb" {
  name        = "${random_pet.randy.id}_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${random_pet.randy.id}-alb-security-group"
  }
}

resource "aws_lb" "test" {
  name               = "${random_pet.randy.id}-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [data.aws_subnet.subnet.id, data.aws_subnet.subnet1.id]

  enable_deletion_protection = false


  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "${random_pet.randy.id}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

locals {
  azes = [data.aws_subnet.subnet.availability_zone, data.aws_subnet.subnet1.availability_zone]
}
