output "key_arn" {
  value       = aws_kms_key.key.arn
  description = "The ARN of the customer-managed key"
}
