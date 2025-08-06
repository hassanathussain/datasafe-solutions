resource "aws_iam_role" "hr_role" {
  name = "HRAccessRole"

  assume_role_policy = data.aws_iam_policy_document.hr_trust.json
}

resource "aws_iam_role_policy_attachment" "hr_attach" {
  role       = aws_iam_role.hr_role.name
  policy_arn = aws_iam_policy.hr_policy.arn
}

resource "aws_iam_role" "finance_role" {
  name = "FinanceAccessRole"

  assume_role_policy = data.aws_iam_policy_document.finance_trust.json
}

resource "aws_iam_role_policy_attachment" "finance_attach" {
  role       = aws_iam_role.finance_role.name
  policy_arn = aws_iam_policy.finance_policy.arn
}

resource "aws_iam_role" "marketing_role" {
  name = "MarketingAccessRole"

  assume_role_policy = data.aws_iam_policy_document.marketing_trust.json
}

resource "aws_iam_role_policy_attachment" "marketing_attach" {
  role       = aws_iam_role.marketing_role.name
  policy_arn = aws_iam_policy.marketing_policy.arn
}

data "aws_iam_policy_document" "hr_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "finance_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "marketing_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_caller_identity" "current" {}