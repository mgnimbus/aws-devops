###################
# EC2 Instance role
###################

# Sts policy
data "aws_iam_policy_document" "imdsv2_sts_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "imdsv2_role" {
  name               = "imdsv2ec2_role_imdsv2"
  assume_role_policy = data.aws_iam_policy_document.imdsv2_sts_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    aws_iam_policy.imdsv2_policy.arn
  ]
}

# IAM Policy
resource "aws_iam_policy" "imdsv2_policy" {
  name = "imdsv2_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:MetadataHttpEndpoint",
          "ec2:MetadataHttpPutResponseHopLimit",
          "ec2:MetadataHttpTokens",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Instance Profile
resource "aws_iam_instance_profile" "imdsv2_profile" {
  name = "imdsv2_ec2_profile"
  role = aws_iam_role.imdsv2_role.name
}


