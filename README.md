# DataSafe S3 Secure Access (Terraform)

This project provisions a secure, multi-department S3 storage system using Terraform, IAM roles, and CloudTrail. Built for a mock company (**DataSafe Solutions**) to demonstrate role-based access and AWS best practices.

---

## 🚀 What's Inside

### 🪣 S3 Storage
- Single bucket with three prefixes: `HR/`, `Finance/`, `Marketing/`
- SSE-S3 encryption enabled
- Public access completely blocked

### 🔐 IAM Access Control
- Three IAM roles: `HRAccessRole`, `FinanceAccessRole`, `MarketingAccessRole`
- Folder-level permission boundaries
- IAM users (`hr_user`, `finance_user`, `marketing_user`) can only assume their own roles

### 📜 CloudTrail Logging
- Separate S3 bucket for logs
- Includes object-level data events for full auditability

### 📄 Sample Data
- Simple `.txt` files preloaded for testing access per department

---

## 📁 Project Structure

.
├── cloudtrail/ # CloudTrail configuration
├── iam/ # IAM roles, policies, users
├── sample_data/ # Sample files per department
├── sample_data_upload.tf # Upload logic for test files
├── main.tf # Root module (S3 + modules)
├── outputs.tf # Terraform outputs (bucket + role ARNs)
└── docs/ # User guide, test logs, mistakes & insights


---

## 🛠️ How to Deploy

1. **Initialize**

   ```bash
   terraform init

Set Variables

Via terraform.tfvars or CLI flags:

region                  = "us-east-2"
cloudtrail_bucket_name = "<unique-log-bucket-name>"
