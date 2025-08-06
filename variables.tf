variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for department data"
  type        = string
}