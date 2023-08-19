resource "aws_s3_bucket" "nimbus" {
  bucket = "nimbuscloudstorage"

  tags = {
    Name        = "NimbusCloud"
    Environment = "Prod"
  }
}


resource "aws_s3_bucket" "site" {
  bucket = "nimbuscloudwebsite"

  tags = {
    Name        = "NimbusCloud"
    Environment = "Prod"
  }
}
