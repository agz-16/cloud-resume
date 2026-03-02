# SECTION 1 — Package Lambda code

data "archive_file" "lambda_zip" {
  type        = "zip"                                         
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/lambda.zip"                  
}

# SECTION 2 — IAM Role for Lambda (trust policy)

resource "aws_iam_role" "lambda_exec_role" {
  name = "cloud_resume_lambda_role"

  # Trust policy: allows the Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

# SECTION 3 — IAM Policy (CloudWatch Logs + DynamoDB table)

resource "aws_iam_policy" "lambda_policy" {
  name        = "cloud_resume_lambda_policy"
  description = "Resume Lambda permissions: CloudWatch Logs + DynamoDB (cloud-resume-test)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # CloudWatch Logs permissions
      {
        Sid    = "AllowCloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },

      # DynamoDB table permissions
      {
        Sid    = "AllowDynamoDBTableReadWrite"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/cloud-resume-test"
      }
    ]
  })
}

# SECTION 4 — Attach policy to the role

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# SECTION 5 — Lambda function deployment

resource "aws_lambda_function" "resume_lambda" {
  function_name = "cloud-resume-api-tf" # Lambda name in AWS

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role    = aws_iam_role.lambda_exec_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.11"
}

# SECTION 6 — Public Lambda Function URL + CORS

resource "aws_lambda_function_url" "resume_lambda_url" {
  function_name      = aws_lambda_function.resume_lambda.function_name
  authorization_type = "NONE"
}

# Output prints the endpoint after terraform apply.

output "lambda_function_url" {
  value       = aws_lambda_function_url.resume_lambda_url.function_url
  description = "Public Lambda Function URL"
}

output "lambda_function_name" {
  value       = aws_lambda_function.resume_lambda.function_name
  description = "Lambda function name"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.resume_lambda.arn
  description = "Lambda ARN"
}