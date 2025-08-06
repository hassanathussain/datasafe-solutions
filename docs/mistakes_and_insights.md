### 📄 `docs/mistakes_and_insights.md`

```markdown
# 🧠 Mistakes, Misconfigurations & Insights

This document captures real-world engineering mistakes, IAM misconfigurations, and learnings from building a secure S3-based access control system using Terraform. These are not just errors—they’re lessons worth sharing.

---

## 🔐 1. IAM Users Cannot Be Deleted If They Have Access Keys

### ❌ What Happened:
Terraform failed during `terraform destroy`:
```

Error: deleting IAM User: DeleteConflict: Cannot delete entity, must delete access keys first.

````

### 💡 Insight:
IAM users with active access keys cannot be destroyed via Terraform unless the keys are also managed in code (which is discouraged). This leads to "dangling resources" in your state unless you manually revoke keys.

### ✅ Recommendation:
- Use **IAM roles** + **temporary credentials** instead of long-lived users/keys.
- If users are necessary, manage access keys explicitly with `aws_iam_access_key` and set `lifecycle { prevent_destroy = true }` for safety.
- Alternatively, shift to using **SSO or identity federation**.

---

## 🔑 2. Missing `s3:ListBucket` on Bucket vs Prefix Scopes

### ❌ What Happened:
Users with proper `s3:GetObject` permissions still couldn't access objects.

### 💡 Insight:
To download or view objects inside a folder-like prefix (`s3://bucket/HR/`), users must also have:
```json
{
  "Action": "s3:ListBucket",
  "Resource": "arn:aws:s3:::bucket-name",
  "Condition": {
    "StringLike": {
      "s3:prefix": "HR/*"
    }
  }
}
````

Without this, users can’t even “see” the objects inside the bucket—even if they have read/write access to those objects.

### ✅ Recommendation:

Always pair object-level actions with bucket-level `ListBucket` permissions scoped by `s3:prefix`.

---

## 👮 3. Role Assumption Works — But Only When the Trust Policy Matches

### ❌ What Happened:

Even after assigning `AssumeRole` permissions, `sts:assume-role` failed.

### 💡 Insight:

It’s not enough to grant permission in the IAM policy—**the trust policy of the role** must allow the user or group to assume it. It’s a two-way handshake:

* IAM policy → “I am allowed to assume X”
* Trust policy on role → “I trust Y to assume me”

### ✅ Recommendation:

Double-check the trust policy:

```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::ACCOUNT_ID:user/hr_user"
  },
  "Action": "sts:AssumeRole"
}
```

Or better yet, use IAM groups or roles as principals to simplify management.

---

## 🪪 4. Typos in IAM ARNs or Actions Silently Fail

### ❌ What Happened:

Policy attached successfully, but permissions weren’t working.

### 💡 Insight:

AWS doesn't validate the existence of IAM principals or action names inside a policy. A typo like `s3:PutObect` (missing "j") won’t throw an error—it’ll just silently do nothing.

### ✅ Recommendation:

* Use **Terraform validations or JSON schema linters** for policies.
* Keep actions lowercase and double-check against AWS docs.

---

## 🗃️ 5. Overly Broad Policies Felt Tempting, but Hurt Security Goals

### ❌ What Happened:

Early tests used `"Action": "s3:*"` just to make things work.

### 💡 Insight:

This defeats the entire purpose of scoped access. It makes detection of misconfigurations harder later, especially when you try to lock down access.

### ✅ Recommendation:

* Always start **least-privilege first**—you can expand later.
* Use Terraform locals or variables to standardize actions and prefixes per department.

---

## 🧪 6. Testing Role Assumption Without Exporting Credentials

### ❌ What Happened:

You assumed a role successfully via `sts assume-role`, but subsequent `aws s3` calls failed.

### 💡 Insight:

The CLI doesn’t automatically use the temporary credentials from `assume-role`. You must export them:

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...
```

Without these, you're still using the *original user’s credentials*.

---

## 🔁 7. S3 Prefix Simulation ≠ Real Folders

### ❌ What Happened:

Expecting that creating a file inside `sample_data/HR/` in Terraform would simulate a folder in S3.

### 💡 Insight:

S3 is flat. Folders are logical prefixes only. Each file must include its full key like `HR/sample_hr.txt`.

Terraform's `aws_s3_object` requires `key = "HR/sample_hr.txt"`—not just `filename`.

---

## 📜 8. CloudTrail Data Events Not Enabled by Default

### ❌ What Happened:

S3 access was being logged, but **object-level API calls (e.g., `GetObject`) weren’t showing up**.

### 💡 Insight:

S3 data events (like `GetObject`, `PutObject`) are **not enabled** by default in CloudTrail. You must explicitly enable them per bucket.

### ✅ Fix:

In Terraform:

```hcl
data_resource {
  type = "AWS::S3::Object"
  values = ["arn:aws:s3:::your-bucket-name/"]
}
```

---

## 🧽 9. Cleanup Failures Without Conditional Resource Teardown

### ❌ What Happened:

Partial destroy operations led to dangling state due to missing dependency awareness.

### 💡 Insight:

Terraform doesn’t inherently understand that an IAM role is “dependent” on the existence of a user who assumes it.

### ✅ Recommendation:

* Use `depends_on` judiciously when creating tightly coupled resources (users → roles → policies)
* Consider `count = var.create_user ? 1 : 0` pattern to allow optional user creation in dev/testing

---

## 🎯 10. IAM Role Session Tokens Are Time-Bound and Frustrating to Reuse

### ❌ What Happened:

Assumed a role, left for a break, came back and `s3 ls` failed.

### 💡 Insight:

Session credentials from `sts:assume-role` expire (default: 1 hour). You must re-assume the role and re-export credentials.

### ✅ Tip:

Use a short shell script to refresh and export credentials:

```bash
eval $(aws sts assume-role ... | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId)\nexport AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\nexport AWS_SESSION_TOKEN=\(.SessionToken)"')
```

---

## 🧵 Final Thoughts

* IAM is powerful, but unintuitive.
* S3 isn’t a traditional filesystem—its permissions are prefix-based, not folder-based.
* AssumeRole adds security, but debugging it requires careful attention to both trust policies and credentials.
* Terraform is declarative—but **deleting** things in the right order is your responsibility.

This was more than a project—it was an **education in security, infrastructure idempotence, and AWS realism**.

---

## 🙌 Built By

~Hassanat

```