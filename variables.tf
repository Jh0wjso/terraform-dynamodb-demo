variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "table_name" {
  description = "Base name of the DynamoDB table"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}
