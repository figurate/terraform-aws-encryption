/**
 * # ![AWS](aws-logo.png) KMS customer-managed key (CMK)
 *
 * Purpose: Configure a KMS key
 */
resource "aws_kms_key" "key" {
  description         = var.description
  enable_key_rotation = true
}

resource "aws_kms_alias" "key" {
  count         = var.alias != null ? 1 : 0
  target_key_id = aws_kms_key.key.id
  name          = "alias/${var.alias}"
}
