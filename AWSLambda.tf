# Zip the function to be run at function app

data "archive_file" "init"{
    type = "zip"
    source_file ="${path.module}/Project/hello.js"
    output_path = "${path.module}/hello.js"
}

# S3 bucket

resource "aws_s3_bucket" "example-s3" {
  bucket = "example-s3-bucket"

  tags = {
    Name        = "My bucket"
  }
}


# upload zip file to s3 bucket

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.example-s3.id
  key = hello.zip
  source = "${path.module}/hello.js"
}

# IAM role for lambda

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = file("Project/lambda_assume_role_policy.json")
}

# Iam Role policy for lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = file("Project/lambda_policy.json")
}

# AWS Lambda functions
resource "aws_lambda_function" "test_lambda" {
  function_name = "hello"
  s3_bucket = aws_s3_bucket.example-s3.id
  s3_key = "hello.zip"
  role = aws_iam_role.lambda_role.arn
  handler = "hello.handler"
  runtime = "nodejs12.x"
}