resource "aws_iam_user" "hr_user" {
  name = "hr_user"
}

resource "aws_iam_user" "finance_user" {
  name = "finance_user"
}

resource "aws_iam_user" "marketing_user" {
  name = "marketing_user"
}

resource "aws_iam_user_policy_attachment" "hr_assume_role" {
  user       = aws_iam_user.hr_user.name
  policy_arn = aws_iam_policy.hr_assume_policy.arn
}

resource "aws_iam_user_policy_attachment" "finance_assume_role" {
  user       = aws_iam_user.finance_user.name
  policy_arn = aws_iam_policy.finance_assume_policy.arn
}

resource "aws_iam_user_policy_attachment" "marketing_assume_role" {
  user       = aws_iam_user.marketing_user.name
  policy_arn = aws_iam_policy.marketing_assume_policy.arn
}