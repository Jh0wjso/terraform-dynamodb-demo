variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Lambda handler (file.function)"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "table_arn" {
  description = "DynamoDB table ARN to grant PutItem access"
  type        = string
}
