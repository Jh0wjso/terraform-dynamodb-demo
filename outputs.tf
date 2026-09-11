output "table_name" {
  description = "Full DynamoDB table name"
  value       = module.dynamodb_table.table_name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb_table.table_arn
}

output "ec2_iam_role_arn" {
  description = "IAM Role for EC2 to interact with this DynamoDB Table"
  value       = resource.aws_iam_role.dynamodb_access_role.arn
}

output "db_connection_string" {
  description = "Connection string for the DynamoDB database"
  value       = "https://dynamodb.${var.aws_region}.amazonaws.com/${module.dynamodb_table.table_name}"
}

output "lambda_name" {
  description = "Name of the Lambda function"
  value       = module.lambda_function.function_name
}
