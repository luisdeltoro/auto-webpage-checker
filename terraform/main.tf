# Define the IAM role for the Lambda function
resource "aws_iam_role" "awc_lambda" {
  name = "awc_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the SNS publishing policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_sns_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.awc_lambda.name
}

data "aws_ecr_repository" "awc_lambda" {
  name = "awc-lambda"
}

# Define the Lambda function
resource "aws_lambda_function" "awc" {
  image_uri        = "${data.aws_ecr_repository.awc_lambda.repository_url}:latest"
  package_type     = "Image"
  function_name    = "awc-function"
  role             = aws_iam_role.awc_lambda.arn
  timeout          = 600 # Update to set the Lambda function timeout to 10 minutes (in seconds)

  # Define the environment variables for the Lambda function
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.awc-main.arn
      NOTIFICATION_MODE = "ON_SUCCESS"
    }
  }
}

# Grant the Lambda function permission to publish to the SNS topic
resource "aws_iam_role_policy_attachment" "sns_publish" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess" # Attach the SNS Full Access policy to the IAM Role
  role       = aws_iam_role.awc_lambda.name
}