output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.datasafe_storage.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.datasafe_storage.arn
}

output "hr_folder_url" {
  value = "https://${aws_s3_bucket.datasafe_storage.bucket}.s3.amazonaws.com/HR/README.md"
}

output "hr_role_arn" {
  description = "ARN of the IAM role for HR"
  value       = module.iam_roles.hr_role_arn
}

output "finance_role_arn" {
  description = "ARN of the IAM role for Finance"
  value       = module.iam_roles.finance_role_arn
}

output "marketing_role_arn" {
  description = "ARN of the IAM role for Marketing"
  value       = module.iam_roles.marketing_role_arn
}