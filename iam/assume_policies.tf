resource "aws_iam_policy" "hr_assume_policy" {
  name        = "HRAssumeRolePolicy"
  description = "Allows hr_user to assume HRAccessRole"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sts:AssumeRole",
      Resource = aws_iam_role.hr_role.arn
    }]
  })
}

resource "aws_iam_policy" "finance_assume_policy" {
  name        = "FinanceAssumeRolePolicy"
  description = "Allows finance_user to assume FinanceAccessRole"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sts:AssumeRole",
      Resource = aws_iam_role.finance_role.arn
    }]
  })
}

resource "aws_iam_policy" "marketing_assume_policy" {
  name        = "MarketingAssumeRolePolicy"
  description = "Allows marketing_user to assume MarketingAccessRole"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sts:AssumeRole",
      Resource = aws_iam_role.marketing_role.arn
    }]
  })
}