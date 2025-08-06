output "hr_role_arn" {
  value = aws_iam_role.hr_role.arn
}

output "finance_role_arn" {
  value = aws_iam_role.finance_role.arn
}

output "marketing_role_arn" {
  value = aws_iam_role.marketing_role.arn
}