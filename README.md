## README.md

```markdown
# DataSafe S3 Secure Access (Terraform)

This repository contains Terraform code to provision a secure, multi-department S3 file storage system using IAM roles, policies, and CloudTrail logging. It's built for a fictitious company (**DataSafe Solutions**) to demonstrate least-privilege access controls using AWS best practices.

---

## 🚀 Project Overview

- **S3 Setup**  
  - One bucket with *three prefixes*: `HR/`, `Finance/`, `Marketing/`  
  - SSE-S3 encryption enabled  
  - Public access fully blocked (ACLs, policies)

- **IAM Access Control**  
  - Three roles: `HRAccessRole`, `FinanceAccessRole`, `MarketingAccessRole`  
  - Fine-grained IAM policies scoped by folder prefix  
  - Three IAM users (`hr_user`, `finance_user`, `marketing_user`) that can only assume their respective roles

- **CloudTrail Logging**  
  - Logs everything to a separate S3 bucket  
  - Includes S3 object-level data events for full auditing

- **Sample Data**  
  - Basic `.txt` files pre-loaded in each department folder to test read/write access

---

## 📁 Directory Structure

```

.
├── cloudtrail/             # CloudTrail configuration
├── iam/                    # IAM roles, policies, users
├── sample\_data/            # Sample files for upload
├── sample\_data\_upload.tf   # Upload logic for sample data
├── main.tf                 # Root module (S3 + modules)
├── outputs.tf              # Core Terraform outputs (bucket + role ARNs)
└── docs/                   # Documentation: user guide, test reports, screenshots

````

---

## 🛠️ How to Deploy

1. **Initialize Terraform**  
   ```bash
   terraform init
````

2. **Provide variables** (via `terraform.tfvars` or `-var` flags). At minimum:

   ```hcl
   region                   = "us-east-2"
   cloudtrail_bucket_name  = "<unique-log-bucket-name>"
   ```

3. **Plan and Apply**

   ```bash
   terraform plan
   terraform apply
   ```

4. **Retrieve Role ARNs**

   ```bash
   terraform output
   ```

5. **Assume Roles using AWS CLI or SDK** with the role ARNs and test S3 access.

---

## 🧪 Testing Workflow

* Configure AWS CLI for a user (e.g. `hr_user`)
* Assume the corresponding role:

  ```bash
  aws sts assume-role --role-arn <HR_ROLE_ARN> --role-session-name hr_test
  ```
* Export temporary credentials and test access:

  ```bash
  aws s3 ls s3://<bucket>/HR/              # ✅ success
  aws s3 ls s3://<bucket>/Finance/          # ❌ should be denied
  ```

Repeat similar tests for `finance_user` and `marketing_user`.

---

## 🧠 Lessons & Gotchas

See `docs/mistakes_and_insights.md` for a detailed list of real-world mistakes, policy traps (e.g., missing `ListBucket`, silent IAM typos), and engineering lessons learned.

---

## 🧾 Cleanup

```bash
terraform destroy
```

> ⚠️ Make sure to **delete IAM user access keys manually**, or configure managed keys in Terraform with `sensitive = true`, so destroy operations succeed without cleanup errors.

---

## 🌟 Why This Matters

* **Least-privilege first**: Each role can only act within its own folder (and Finance has read-only access to HR).
* **Audited and secure**: SSE encryption + CloudTrail data logs for compliance.
* **Modular & reusable**: Easy to replicate for other department setups or scale with live data on GitHub.

---

## 📬 Feedback or Contributions?

Want help extending this example with KMS encryption, lifecycle rules, or versioning? Open an issue or pull request!
— Hassanat (@\[your\_handle])

````

---

### ✅ About the public GitHub repo

I'm **not able to programmatically create or push code to GitHub** on your behalf. You can:

1. Create a new public repository on GitHub
2. Add this README.md as your project’s homepage
3. `git init` (if not already), commit your current directory contents
4. Add the remote URL and push:
   ```bash
   git remote add origin https://github.com/<username>/<repo-name>.git
   git push -u origin main
````

That way your repo will include:

* Terraform code
* Sample files
* Docs with mistakes & test results
* README as roadmap