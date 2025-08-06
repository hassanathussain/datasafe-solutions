resource "aws_s3_object" "finance_sample" {
  bucket     = aws_s3_bucket.datasafe_storage.bucket
  key        = "Finance/sample_finance.txt"
  source     = "${path.module}/sample_data/finance/sample_finance.txt"
  etag       = filemd5("${path.module}/sample_data/finance/sample_finance.txt")
  depends_on = [aws_s3_bucket.datasafe_storage]
}

resource "aws_s3_object" "hr_sample" {
  bucket     = aws_s3_bucket.datasafe_storage.bucket
  key        = "HR/sample_hr.txt"
  source     = "${path.module}/sample_data/hr/sample_hr.txt"
  etag       = filemd5("${path.module}/sample_data/hr/sample_hr.txt")
  depends_on = [aws_s3_bucket.datasafe_storage]
}

resource "aws_s3_object" "marketing_sample" {
  bucket     = aws_s3_bucket.datasafe_storage.bucket
  key        = "Marketing/sample_marketing.txt"
  source     = "${path.module}/sample_data/marketing/sample_marketing.txt"
  etag       = filemd5("${path.module}/sample_data/marketing/sample_marketing.txt")
  depends_on = [aws_s3_bucket.datasafe_storage]
}