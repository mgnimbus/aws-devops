resource "aws_instance" "efs" {
  ami               = "ami-069aabeee6f53e7bf"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "tfkey"
  user_data         = file("${path.module}/ec2-user-data.sh")
  # security_groups      = [aws_security_group.allow_efs.name]
  # iam_instance_profile = aws_iam_instance_profile.ec2-iam-profile.name
  tags = {
    Name = "mgm-ec2-devop-cert"
  }
}


resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 2

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.efs.id
}
