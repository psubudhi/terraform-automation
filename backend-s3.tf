terraform {
  backend "s3" {
    bucket = "terraform-prometheus-backend"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_iam_role" "terraform_backend_role" {
  name               = "terraform-backend-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_backend_policy" {
  name        = "terraform-backend-policy"
  description = "Policy for Terraform S3 backend access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::terraform-prometheus-backend",
          "arn:aws:s3:::terraform-prometheus-backend/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_backend_policy" {
  role       = aws_iam_role.terraform_backend_role.name
  policy_arn = aws_iam_policy.terraform_backend_policy.arn
}
