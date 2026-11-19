terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "ap-south-1"
}

variable "user_name" {
  default = "s3-readonly-demo-user"
}

variable "s3_read_policy" {
  description = "IAM policy document granting S3 read-only access"
  default = {
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket", "s3:ListAllMyBuckets"]
      Resource = "*"
    }]
  }
}

resource "aws_iam_user" "demo" {
  name = var.user_name
}

resource "aws_iam_policy" "s3_read" {
  name   = "s3-read-only-policy-demo"
  policy = jsonencode(var.s3_read_policy)
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.demo.name
  policy_arn = aws_iam_policy.s3_read.arn
}

output "user_name" {
  value = aws_iam_user.demo.name
}

output "policy_arn" {
  value = aws_iam_policy.s3_read.arn
}
