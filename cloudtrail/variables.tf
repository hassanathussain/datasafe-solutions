variable "cloudtrail_bucket_name" {
  description = "S3 bucket to store CloudTrail logs"
  type        = string
}

variable "trail_name" {
  description = "CloudTrail trail name"
  type        = string
  default     = "datasafe-s3-trail"
}