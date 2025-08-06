provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "datasafe_storage" {
  bucket = "datasafe-department-storage-hsn" # Change bucket name to be globally unique

  force_destroy = true

  tags = {
    Name        = "DepartmentStorage"
    Environment = "Dev"
    Owner       = "DataSafeSolutions"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.datasafe_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.datasafe_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.datasafe_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "hr_folder" {
  bucket  = aws_s3_bucket.datasafe_storage.id
  key     = "HR/README.md"
  content = "This is the HR folder"
}

resource "aws_s3_object" "finance_folder" {
  bucket  = aws_s3_bucket.datasafe_storage.id
  key     = "Finance/README.md"
  content = "This is the Finance folder"
}

resource "aws_s3_object" "marketing_folder" {
  bucket  = aws_s3_bucket.datasafe_storage.id
  key     = "Marketing/README.md"
  content = "This is the Marketing folder"
}

module "iam_roles" {
  source      = "./iam"
  bucket_name = aws_s3_bucket.datasafe_storage.bucket
}

module "cloudtrail" {
  source                 = "./cloudtrail"
  cloudtrail_bucket_name = "datasafe-cloudtrail-logs-hsn" # bucket name must be unique
}