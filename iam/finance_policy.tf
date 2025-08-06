resource "aws_iam_policy" "finance_policy" {
  name        = "FinanceAccessPolicy"
  description = "Finance full access to Finance, read-only to HR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "FinanceFullAccess"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.bucket_name}/Finance/*"
      },
      {
        Sid      = "FinanceListFinance"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${var.bucket_name}"
        Condition = {
          StringLike = {
            "s3:prefix" = ["Finance/*"]
          }
        }
      },
      {
        Sid      = "ReadHR"
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "arn:aws:s3:::${var.bucket_name}/HR/*"
      },
      {
        Sid      = "ListHR"
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