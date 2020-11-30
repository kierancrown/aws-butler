provider "aws" {
  region  = "eu-west-1"
  profile = "personal"
}

terraform {
  backend "s3" {}
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Created Policy for IAM Role
resource "aws_iam_policy" "policy" {
  name        = "butler-s3-policy"
  description = "A test policy"


  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "logs:*"
         ],
         "Resource":"arn:aws:logs:*:*:*"
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:*"
         ],
         "Resource":"arn:aws:s3:::*"
      },
      {
         "Effect":"Allow",
         "Action":[
            "lambda:ListFunctions"
         ],
         "Resource":"*"
      }
   ]
}
    EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_payload.zip"
  function_name = "aws_butler_runner"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.handler"

  source_code_hash = filebase64sha256("lambda_payload.zip")

  runtime = "nodejs12.x"

  timeout = 30
  description = "This lambda runs on schedule and scans this AWS account for resources"

  environment {
    variables = {
      "config": jsonencode(var.butler_config),
      "alerts": jsonencode(var.butler_alerts),
      "snsArn": aws_sns_topic.butler_alerts.arn
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_one_hour" {
  name                = "every-hour"
  description         = "Fires every one hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "run_check_every_one_hour" {
  rule      = aws_cloudwatch_event_rule.every_one_hour.name
  target_id = "test_lambda"
  arn       = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_one_hour.arn
}

resource "aws_sns_topic" "butler_alerts" {
  name = "aws-butler-alerts-topic"
}