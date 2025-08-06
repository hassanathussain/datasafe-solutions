# 🧠 Mistakes, Misconfigurations & Insights

This isn’t just a list of things that went wrong. It’s a map of the traps, blind spots, and edge cases that show up when building secure AWS infrastructure using Terraform and IAM. Every mistake here taught us something.

---

## 🔐 1. IAM Users Can’t Be Destroyed If They Have Access Keys

### ❌ What Happened:

Terraform threw an error on `terraform destroy`:

Error: deleting IAM User: DeleteConflict: Cannot delete entity, must delete access keys first.


### 💡 Insight:

If a user has an active access key, Terraform won’t delete them—unless the key itself is being managed (which is usually discouraged).

### ✅ Recommendation:

- Prefer **IAM roles** + **temporary credentials**
- If you must use users, manage keys via `aws_iam_access_key` and mark them with:
  ```hcl
  lifecycle {
    prevent_destroy = true
  }

Better yet: use SSO or identity federation for access.
