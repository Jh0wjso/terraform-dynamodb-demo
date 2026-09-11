provider "aws" {
  region = var.aws_region
}

module "dynamodb_table" {
  #source = "./modules/dynamodb_table_hardcoded"
  source = "./modules/dynamodb_table"

  table_name  = var.table_name
  environment = var.environment
}

module "lambda_function" {
  source = "./modules/lambda_function"

  function_name = "${var.environment}-${var.table_name}-lambda"
  handler       = "index.handler"
  runtime       = "python3.8"
  table_arn     = module.dynamodb_table.table_arn

  environment_variables = {
    TABLE_NAME = module.dynamodb_table.table_name
  }
}

# IAM Role, Policy, and Role Policy Attachment
resource "aws_iam_role" "dynamodb_access_role" {
  name = "${module.dynamodb_table.table_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "${module.dynamodb_table.table_name}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = module.dynamodb_table.table_arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.dynamodb_access_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}
