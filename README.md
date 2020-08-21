# ![AWS](aws-logo.png) KMS customer-managed key (CMK)

Purpose: Configure a KMS key

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alias | An alias string associated with the key | `any` | `null` | no |
| description | The key description | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| key\_arn | The ARN of the customer-managed key |

