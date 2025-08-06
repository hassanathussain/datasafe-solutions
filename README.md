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

## 🛠️ How to Deploy

1. **Initialize**

   ```bash
   terraform init


2. **Set Variables**

   Via `terraform.tfvars` or CLI flags:

   ```hcl
   region                  = "us-east-2"
   cloudtrail_bucket_name = "<unique-log-bucket-name>"
   ```

3. **Plan and Apply**

   ```bash
   terraform plan
   terraform apply
   ```

4. **Get Output Values**

   ```bash
   terraform output
   ```

5. **Assume Role & Test Access**

   ```bash
   aws sts assume-role --role-arn <HR_ROLE_ARN> --role-session-name hr_test
   ```

   Export the credentials and test:

   ```bash
   aws s3 ls s3://<bucket-name>/HR/       # ✅ should work
   aws s3 ls s3://<bucket-name>/Finance/  # ❌ should be denied
   ```

   Repeat for `finance_user` and `marketing_user`.

---

## 🧠 Common Mistakes & Insights

See [`docs/mistakes_and_insights.md`](docs/mistakes_and_insights.md) for lessons on:

* `ListBucket` permission gaps
* Silent IAM typos
* Role assumption failures
* Debugging tips

---

## 🧹 Cleanup

```bash
terraform destroy
```

> ⚠️ Delete IAM user access keys manually if created outside Terraform, or use `sensitive = true` with managed keys to avoid destroy errors.

---

## 🌟 Why It Matters

* **Secure by default**: encryption, access controls, and logging
* **Least-privilege enforced**: strict folder-level access
* **Reusable**: easy to extend to new departments or datasets

---

## 🤝 Contribute or Extend?

Ideas to build on:

* Add KMS encryption
* Enable versioning
* Add S3 lifecycle rules

Open a PR or reach out — Hassanat (\[@your\_handle]).

---

## 📬 Publishing This on GitHub

To make it public:

1. Create a new GitHub repo
2. Add this `README.md`
3. Push your code:

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/<username>/<repo-name>.git
   git push -u origin main
   ```