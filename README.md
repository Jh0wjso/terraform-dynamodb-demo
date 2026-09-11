# terraform-dynamodb-demo

A Terraform demo project that provisions a DynamoDB table using a reusable module, a Lambda function to insert data, and an IAM Role and Policy for EC2 access.

## Structure

```
.
├── main.tf                          # Provider, modules and IAM resources
├── outputs.tf                       # Root outputs
├── variables.tf                     # Root variable declarations
├── terraform.tfvars                 # Variable values (not committed)
├── python/
│   └── index.py                     # Lambda function handler
└── modules/
    ├── dynamodb_table/              # Parameterized DynamoDB module (recommended)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── dynamodb_table_hardcoded/    # Hardcoded values module (reference)
    └── lambda_function/             # Lambda function module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- AWS CLI configured with valid credentials
- Permissions to create DynamoDB, Lambda, and IAM resources

## Configuration

Create a `terraform.tfvars` file at the root with the following content:

```hcl
table_name  = "users"
environment = "dev"
```

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
| `aws_iam_role_policy_attachment` | Attaches the policy to the EC2 role |
| `aws_lambda_function` | Lambda function to insert items into DynamoDB |
| `aws_iam_role` (Lambda) | Role assumable by Lambda with `PutItem` and CloudWatch Logs permissions |

## Root Variables

| Name | Description | Type | Default |
|---|---|---|---|
| `table_name` | Base name of the DynamoDB table | `string` | `"users"` |
| `environment` | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` |

## `dynamodb_table` Module

### Inputs

| Name | Description | Type | Required |
|---|---|---|---|
| `table_name` | Base name of the table | `string` | yes |
| `environment` | Environment name | `string` | yes |

### Outputs

| Name | Description |
|---|---|
| `table_name` | Full table name (`<table_name>-<environment>`) |
| `table_arn` | DynamoDB table ARN |

## `lambda_function` Module

### Inputs

| Name | Description | Type | Required |
|---|---|---|---|
| `function_name` | Lambda function name | `string` | yes |
| `handler` | Handler in `file.function` format | `string` | yes |
| `runtime` | Lambda runtime | `string` | yes |
| `table_arn` | DynamoDB table ARN to grant `PutItem` access | `string` | yes |
| `environment_variables` | Environment variables for the function | `map(string)` | no |

### Outputs

| Name | Description |
|---|---|
| `function_name` | Lambda function name |
| `function_arn` | Lambda function ARN |

## Root Outputs

| Name | Description |
|---|---|
| `table_name` | Full DynamoDB table name |
| `table_arn` | DynamoDB table ARN |
| `ec2_iam_role_arn` | IAM Role ARN for EC2 |
| `lambda_name` | Lambda function name |

## Testing the Lambda

To test the Lambda via the AWS Console test tab, use the following JSON payload:

```json
{
  "body": "{\"name\": \"John Doe\", \"email\": \"john@example.com\", \"age\": 30}"
}
```

The handler will generate a unique `id` (UUID) and insert the item into the DynamoDB table.

## Destroy Resources

```bash
terraform destroy
```
