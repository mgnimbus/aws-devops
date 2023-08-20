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

locals {
  azes = [data.aws_subnet.subnet.availability_zone, data.aws_subnet.subnet1.availability_zone]
}

#########
# ALB-SG
#########
resource "aws_security_group" "alb" {
  name        = "${random_pet.randy.id}_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = data.aws_vpc.vpc.id

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

######
# ALB
######

resource "aws_lb" "alb" {
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

# resource "aws_lb_target_group" "tg" {
#   name     = "${random_pet.randy.id}-lb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.vpc.id
# }

# resource "aws_lb_target_group_attachment" "node" {
#   count            = 2
#   target_group_arn = aws_lb_target_group.test.arn
#   target_id        = aws_instance.alb[count.index].id
#   port             = "80"
# }

###############
# Target Group
###############
resource "aws_lb_target_group" "alb_lambda_tg" {
  name        = "alb-lambda-${random_pet.randy.id}"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "alb_lambda" {
  target_group_arn = aws_lb_target_group.alb_lambda_tg.arn
  target_id        = aws_lambda_function.alb_lambda_function.arn
  depends_on       = [aws_lambda_permission.target]
}

###########
# Listener
###########
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_lambda_tg.arn
  }
}

###############
# Lambda role
###############
resource "aws_iam_role" "lambda_iam" {
  name               = "lambda_iam_${random_pet.randy.id}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

##################
# Lambda Function
##################

resource "aws_lambda_function" "alb_lambda_function" {
  function_name    = "alb-tg-${random_pet.randy.id}"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role             = aws_iam_role.lambda_iam.arn
  handler          = "target.lambda_handler"
  runtime          = "python3.11"
  timeout          = 60
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "./scripts/target.py"
  output_path = "./scripts/target.zip"
}

resource "aws_lambda_permission" "target" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alb_lambda_function.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.alb_lambda_tg.arn
}

