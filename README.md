# terraform-dynamodb-demo

A Terraform demo project that provisions a DynamoDB table using a reusable module, along with an IAM Role and Policy for EC2 access.

## Structure

```
.
├── main.tf                          # Provider, module and IAM resources
├── outputs.tf                       # Root outputs
└── modules/
    ├── dynamodb_table/              # Parameterized module (recommended)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── dynamodb_table_hardcoded/    # Hardcoded values module (reference)
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- AWS CLI configured with valid credentials
- Permissions to create DynamoDB and IAM resources

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Provisioned Resources

| Resource | Description |
|---|---|
| `aws_dynamodb_table` | `users-dev` table with `PAY_PER_REQUEST` billing and `id` hash key |
| `aws_iam_role` | Role assumable by EC2 to access the table |
| `aws_iam_policy` | Policy with read and write permissions on DynamoDB |
| `aws_iam_role_policy_attachment` | Attaches the policy to the role |

## `dynamodb_table` Module

### Inputs

| Name | Description | Type | Required |
|---|---|---|---|
| `table_name` | Base name of the table | `string` | yes |
| `environment` | Environment name (e.g., dev, staging, prod) | `string` | yes |

### Outputs

| Name | Description |
|---|---|
| `table_name` | Full table name (`<table_name>-<environment>`) |
| `table_arn` | DynamoDB table ARN |

## Root Outputs

| Name | Description |
|---|---|
| `table_name` | Full table name |
| `table_arn` | Table ARN |
| `ec2_iam_role_arn` | IAM Role ARN for EC2 |

## Destroy Resources

```bash
terraform destroy
```
