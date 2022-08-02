/**
 * # ![AWS](aws-logo.png) KMS customer-managed key (CMK)
 *
 * Purpose: Configure a KMS key
 */
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "admin_access" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
      
    }
  }
}

data "aws_iam_policy_document" "policy" {
  dynamic statement {
    for_each = var.toggle_root_access ? true : false
    content {
      sid       = "Enable IAM User Permissions"
      actions   = ["kms:*"]
      resources = ["*"]
      principals {
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        type        = "AWS"
      }
    }
  }

  dynamic statement {
    for_each = length(var.admins) > 0 ? [1] : []
    content {
      sid = "Allow access for Key Administrators"
      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
      resources = ["*"]
      principals {
        identifiers = var.admins
        type        = "AWS"
      }
    }
  }

  dynamic statement {
    for_each = length(var.users) > 0 ? [1] : []
    content {
      sid = "Allow use of the key"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = ["*"]
      principals {
        identifiers = var.users
        type        = "AWS"
      }
    }
  }

  dynamic statement {
    for_each = length(var.users) > 0 ? [1] : []
    content {
      sid = "Allow attachment of persistent resources"
      actions = [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ]
      resources = ["*"]
      condition {
        test     = "Bool"
        values   = ["true"]
        variable = "kms:GrantIsForAWSResource"
      }
      principals {
        identifiers = var.users
        type        = "AWS"
      }
    }
  }
}

resource "aws_kms_key" "key" {
  description         = var.description
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.policy.json
}

resource "aws_kms_alias" "key" {
  count         = var.alias != null ? 1 : 0
  target_key_id = aws_kms_key.key.id
  name          = "alias/${var.alias}"
}
