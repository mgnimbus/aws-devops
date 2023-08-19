resource "random_pet" "randy" {
  length = 1
}

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
  name                       = "${random_pet.randy.id}-lb-tf"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = [data.aws_subnet.subnet.id, data.aws_subnet.subnet1.id]
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


resource "aws_instance" "alb" {
  count                  = 1
  ami                    = "ami-069aabeee6f53e7bf"
  instance_type          = "t2.micro"
  availability_zone      = local.azes[count.index]
  key_name               = "tfkey"
  user_data              = file("${path.module}/route53.sh")
  vpc_security_group_ids = [aws_security_group.server.id]
  # iam_instance_profile = aws_iam_instance_profile.ec2-iam-profile.name
  tags = {
    Name = "${random_pet.randy.id}-server-${count.index}"
  }
}

resource "aws_security_group" "server" {
  name        = "${random_pet.randy.id}_server_security_group"
  description = "To only alllow traffic coming from load balancer security group"
  vpc_id      = data.aws_vpc.vpc.id


  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # security_groups = [aws_security_group.alb.id] # To only allow traffic from lb
    cidr_blocks = ["0.0.0.0/0"] # To allow traffic from internet
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${random_pet.randy.id}_server_security_group"
  }
}

resource "aws_lb_target_group_attachment" "node" {
  count            = 1
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.alb[count.index].id
  port             = "80"
}

