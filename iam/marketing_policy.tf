resource "aws_iam_policy" "marketing_policy" {
  name        = "MarketingAccessPolicy"
  description = "Allows full access to Marketing folder in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "MarketingFullAccess"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.bucket_name}/Marketing/*"
      },
      {
        Sid      = "ListMarketing"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${var.bucket_name}"
        Condition = {
          StringLike = {
            "s3:prefix" = ["Marketing/*"]
          }
        }
      }
    ]
  })
}