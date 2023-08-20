resource "aws_security_group" "imdsv2_sg" {
  name        = "imdsv2-sg"
  description = "Allow all inbound & outbound traffic"
  vpc_id      = "vpc-0aa0cdbe4c44c04a3"

  ingress {
    description = "allow traffic from internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_trafic"
  }
}
