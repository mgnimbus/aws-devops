
resource "random_pet" "randy" {
  length = 1
}

# Launch template
resource "aws_launch_template" "test" {
  name_prefix   = "${random_pet.randy.id}-asg-template"
  image_id      = "ami-069aabeee6f53e7bf"
  instance_type = "t2.micro"
  user_data     = base64encode(local.user_data)

  vpc_security_group_ids = [aws_security_group.server.id]

}

# ASG
resource "aws_autoscaling_group" "test" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1


  launch_template {
    id      = aws_launch_template.test.id
    version = "$Latest"
  }
}

# attachment to lb
resource "aws_autoscaling_attachment" "test" {
  autoscaling_group_name = aws_autoscaling_group.test.id
  lb_target_group_arn    = aws_lb_target_group.test.arn
}


# Instances SG
resource "aws_security_group" "server" {
  name        = "${random_pet.randy.id}_server_security_group"
  description = "To only alllow traffic coming from internet"
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
    Name = "${random_pet.randy.id}_server_security_group"
  }
}
