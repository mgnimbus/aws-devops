resource "aws_instance" "imdsv2" {
  ami                  = "ami-08a52ddb321b32a8c"
  instance_type        = "t2.micro"
  availability_zone    = "us-east-1a"
  key_name             = "tfkey"
  user_data            = file("${path.module}/imdsv2_script/imdsv2.sh")
  security_groups      = [aws_security_group.imdsv2_sg.name]
  iam_instance_profile = aws_iam_instance_profile.imdsv2_profile.name
  tags = {
    Name = "cloudnimbus-imdsv2"
  }
}
