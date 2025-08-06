# 🚀 DataSafe S3 Secure Access (Terraform)

A secure, departmentalized S3 setup built with Terraform. Imagine one bucket split into HR, Finance & Marketing vaults—all with encryption, strict role‑based access, and full audit logging. Demonstrates IAM best practices and AWS hygiene for **DataSafe Solutions**.

---

## 🧱 Structure at a Glance

* **Single S3 bucket**, neatly divided into `HR/`, `Finance/`, `Marketing/`
* AES‑256 **SSE‑S3 encryption** on all data
* **Public access completely disabled**

IAM infrastructure:

* Roles: `HRAccessRole`, `FinanceAccessRole`, `MarketingAccessRole`
* Users: `hr_user`, `finance_user`, `marketing_user`
* Folder-level IAM policies that strictly isolate each department
* Users can only assume their designated role and nothing else

---

## 🔍 Audit Trail & Monitoring

* Dedicated **CloudTrail logs** stored in a separate bucket
* Captures object-level events—every `GetObject`, `PutObject`, `DeleteObject` is logged

---

## 🧪 Preloaded Demo Files

* Plain `.txt` files in each departmental prefix for testing access
* Helps validate permissions work as intended

---

## ⚙️ Deployment in 5 Simple Steps

1. **Initialize Terraform**

   ```bash
   terraform init
   ```

2. **Configure variables** (`terraform.tfvars` or CLI flags)

   ```hcl
   region                  = "us-east-2"
   cloudtrail_bucket_name = "<your-unique-log-bucket>"
   ```

3. **Review and deploy**

   ```bash
   terraform plan
   terraform apply
   ```

4. **Retrieve outputs**

   ```bash
   terraform output
   ```

5. **Simulate access**

   ```bash
   aws sts assume-role --role-arn <HR_ROLE_ARN> --role-session-name hr_test
   export AWS_ACCESS_KEY_ID=… AWS_SECRET_ACCESS_KEY=… AWS_SESSION_TOKEN=…

   aws s3 ls s3://<bucket>/HR/       # ✅ allowed
   aws s3 ls s3://<bucket>/Finance/  # ❌ denied
   ```

   Repeat for the finance and marketing users.

---

## 💡 Heads-Up: Common Mistakes & Lessons Learned

See [`docs/mistakes_and_insights.md`](docs/mistakes_and_insights.md) to dive into:

* Overlooked `ListBucket` permissions
* Typo‑caused silent policy misfires
* Role assumption pitfalls
* Debugging best practices

---

## 🧼 Cleanup Tips

```bash
terraform destroy
```

If you’ve created IAM access keys outside Terraform, delete them manually—or mark them `sensitive = true` to avoid lifecycle issues.

---

## 🌟 Why It Exists

* **Secure by design**: encryption, explicit denial of public access, strict IAM
* **Least-privilege model**: role-based, folder-specific access only
* **Extendable**: drop in another department or dataset with minimal changes

---

## 🛠️ Build On It

Want to take this further?

* Add **KMS encryption** with key rotation policies
* Enable **S3 versioning** for history and recovery
* Set **lifecycle rules** (tags, archival to Glacier, expiration, etc.)

Your ideas or PRs are welcome—ping Hassanat (\[@your\_handle]) if you want to collaborate.

---

## 📂 Publishing to GitHub

To make this open source:

1. `git init`
2. `git add . && git commit -m "Initial commit"`
3. `git remote add origin https://github.com/<username>/<repo>.git`
4. `git push -u origin main`

---