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

🔑 2. Missing s3:ListBucket Permissions on the Bucket Itself
❌ What Happened:
Users had s3:GetObject, but couldn’t access any objects.

💡 Insight:
S3 needs both bucket-level and object-level permissions. To access s3://bucket/HR/, you need:

{
  "Action": "s3:ListBucket",
  "Resource": "arn:aws:s3:::bucket-name",
  "Condition": {
    "StringLike": {
      "s3:prefix": "HR/*"
    }
  }
}
Without it, the objects are invisible—even if the user has access to the objects themselves.

✅ Fix:
Always pair object-level actions with scoped ListBucket permissions.

👮 3. Role Assumption Breaks If Trust Policy Doesn’t Match
❌ What Happened:
You gave sts:AssumeRole permissions… but assume-role still failed.

💡 Insight:
Granting permission isn’t enough. The trust policy on the role must also explicitly allow the caller to assume it.

Two-way handshake:

IAM policy → “I can assume this role”

Trust policy → “I trust this user to assume me”

✅ Fix:
Ensure the trust policy is set up right:

{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::ACCOUNT_ID:user/hr_user"
  },
  "Action": "sts:AssumeRole"
}
Use groups or roles as Principal for easier scaling.

🪪 4. Typos in IAM Policies Silently Break Things
❌ What Happened:
You attached the policy—but nothing worked.

💡 Insight:
AWS won’t throw an error for typos like s3:PutObect (missing “j”). The policy just silently does nothing.

✅ Fix:
Validate policy JSON before attaching

Use Terraform validations, schema linters, or iam-policy-json-to-terraform tools

🗃️ 5. Broad Wildcard Policies Worked... Until They Didn’t
❌ What Happened:
You used "Action": "s3:*" to speed things up.

💡 Insight:
That’s how misconfigurations creep in. You lose sight of what’s actually allowed, and fine-tuning later becomes painful.

✅ Fix:
Always start with least privilege

Use locals or reusable variables for actions per department

🧪 6. Role Assumed, But CLI Still Used Old Credentials
❌ What Happened:
assume-role worked, but S3 commands failed.

💡 Insight:
The AWS CLI doesn’t use the assumed role by default. You must export the credentials.

export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...
Otherwise, your terminal still uses the old user's credentials.

🔁 7. S3 Prefix ≠ Folder
❌ What Happened:
You thought putting a file in sample_data/HR/ made a folder.

💡 Insight:
S3 is flat. "Folders" are just part of the object key. You have to define the full key:

key = "HR/sample_hr.txt"
📜 8. CloudTrail Doesn’t Log Object Access Unless You Tell It To
❌ What Happened:
GetObject events weren’t showing up in CloudTrail.

💡 Insight:
CloudTrail logs management events by default—not data events. You need to explicitly enable S3 data events:

data_resource {
  type   = "AWS::S3::Object"
  values = ["arn:aws:s3:::your-bucket-name/"]
}
🧽 9. Destroy Failed—Because Resources Were Still Tied Together
❌ What Happened:
terraform destroy only deleted half the stack.

💡 Insight:
IAM roles tied to users or policies that haven’t been destroyed yet can block teardown.

✅ Fix:
Use depends_on when chaining tightly-coupled resources

Use conditional creation with:

count = var.create_user ? 1 : 0
🎯 10. AssumeRole Session Tokens Expire
❌ What Happened:
You left your desk for an hour. When you came back, s3 ls failed.

💡 Insight:
STS tokens expire—by default in 1 hour. You need to re-assume and re-export.

✅ Fix:
Make a helper script:

eval $(aws sts assume-role ... | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId)\nexport AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\nexport AWS_SESSION_TOKEN=\(.SessionToken)"')
🧵 Final Thoughts
This wasn’t just infrastructure. It was a crash course in:

Terraform lifecycle edge cases

How IAM trust actually works

The illusion of folders in S3

Why you should fear typos more than errors

It’s easy to provision infrastructure. The real skill is securing it, breaking it, fixing it—and understanding why each piece behaves the way it does.

🙌 Built by
~ Hassanat