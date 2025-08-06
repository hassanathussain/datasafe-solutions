resource "aws_iam_policy" "hr_policy" {
  name        = "HRAccessPolicy"
  description = "Allows full access to HR folder in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "HRFullAccess"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.bucket_name}/HR/*"
      },
      {
        Sid      = "ListHRFolder"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${var.bucket_name}"
        Condition = {
          StringLike = {
            "s3:prefix" = ["HR/*"]
          }
        }
      }
    ]
  })
}