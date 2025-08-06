## README.md

```markdown
# DataSafe S3 Secure Access (Terraform)

This project sets up a secure, role-based S3 storage system for a fictitious company (**DataSafe Solutions**) using Terraform. It demonstrates least-privilege IAM access, CloudTrail auditing, and secure S3 design.

---

## 🚀 What’s Inside

### 🪣 S3 Storage  
- One bucket with 3 prefixes: `HR/`, `Finance/`, `Marketing/`  
- SSE-S3 encryption  
- Public access fully blocked (ACLs + bucket policy)

### 🔐 IAM Access Control  
- Three IAM roles scoped to each department folder  
- Matching IAM users (`hr_user`, `finance_user`, `marketing_user`)  
- Users can only assume their own role

### 📜 CloudTrail Logging  
- Separate log bucket with object-level logging for full audit trails

### 📂 Sample Data  
- Test `.txt` files uploaded to each folder

---

## 📁 Project Structure

```

.
├── cloudtrail/             # CloudTrail config
├── iam/                    # Users, roles, and policies
├── sample\_data/            # Test files
├── sample\_data\_upload.tf   # Upload logic
├── main.tf                 # Core S3 + module wiring
├── outputs.tf              # Outputs (bucket, roles)
└── docs/                   # User guide, test logs, mistakes

````

---

## 🛠️ Deploy in 5 Steps

1. **Initialize**

   ```bash
   terraform init
````

2. **Set Variables**

   Either in `terraform.tfvars` or via CLI:

   ```hcl
   region                  = "us-east-2"
   cloudtrail_bucket_name = "<your-unique-log-bucket>"
   ```

3. **Plan + Apply**

   ```bash
   terraform plan
   terraform apply
   ```

4. **Get Role ARNs**

   ```bash
   terraform output
   ```

5. **Assume Role & Test**

   ```bash
   aws sts assume-role --role-arn <HR_ROLE_ARN> --role-session-name hr_test
   ```

   Test access:

   ```bash
   aws s3 ls s3://<bucket>/HR/       # ✅ Allowed  
   aws s3 ls s3://<bucket>/Finance/  # ❌ Denied
   ```

Repeat for `finance_user` and `marketing_user`.

---

## 🧠 Common Mistakes & Fixes

See [`docs/mistakes_and_insights.md`](docs/mistakes_and_insights.md) for real-world issues like:

* Missing `ListBucket` permissions
* Silent IAM typos
* Confusing assume-role logic

---

## 🧹 Cleanup

```bash
terraform destroy
```

> ⚠️ Manually delete IAM access keys if managed outside Terraform to avoid destroy errors.

---

## 🌟 Why It Matters

* **Principle of Least Privilege**: Roles are locked to specific prefixes
* **Secure by Default**: Encryption, blocked public access, and logging
* **Reusable Design**: Extendable to other teams or live data setups

---

## 🤝 Want to Contribute?

Ideas for next steps:

* Add KMS encryption
* Lifecycle rules for data
* Versioning support

Open a PR or issue. — Hassanat (@your\_handle)

---

## ✅ Going Public on GitHub?

1. Create a new repo
2. Add this `README.md`
3. Initialize + commit your code:

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/<your-username>/<repo>.git
   git push -u origin main
   ```