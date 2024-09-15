provider "aws" {
  region = "us-east-1"  
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  }
  EOF
}

# IAM policy for Lambda execution
resource "aws_iam_role_policy" "lambda_exec_policy" {
  role   = aws_iam_role.lambda_exec_role.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

# Lambda function
resource "aws_lambda_function" "hello_world" {
  filename         = "lambda.zip"
  function_name    = "hello_world_function"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "hello_world.lambda_handler"
  runtime          = "python3.9"

  source_code_hash = filebase64sha256("lambda.zip")
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "hello_world_api" {
  name        = "HelloWorldAPI"
  description = "API for Hello World Lambda function"
}

# API Gateway Resource (Endpoint)
resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  parent_id   = aws_api_gateway_rest_api.hello_world_api.root_resource_id
  path_part   = "hello"
}

# API Gateway Method (GET request)
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Lambda integration for API Gateway
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  type        = "AWS"
  integration_http_method = "POST"
  uri         = aws_lambda_function.hello_world.invoke_arn
}

# Lambda permission to allow API Gateway to invoke the function
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hello_world_api.execution_arn}/*/*"
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.hello_world_api.id
  stage_name  = "prod"
}

# Output API Gateway URL
output "api_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}/hello"
}
