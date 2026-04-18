# --- IAM Role for Lambda Execution ---

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_exec" {
  name = "team06-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project = "team06"
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "team06-lambda-policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "DynamoDB"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
        ]
        Resource = [
          aws_dynamodb_table.washer_status.arn,
          "${aws_dynamodb_table.washer_status.arn}/stream/*",
          aws_dynamodb_table.user_info.arn
        ]
      },
      {
        Sid    = "IoTData"
        Effect = "Allow"
        Action = [
          "iot:UpdateThingShadow",
          "iot:GetThingShadow"
        ]
        Resource = "*"
      },
      {
        Sid    = "Rekognition"
        Effect = "Allow"
        Action = [
          "rekognition:DetectText"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.images.arn}/*",
          "${aws_s3_bucket.website.arn}/*"
        ]
      },
      {
        Sid    = "S3Bucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.images.arn,
          aws_s3_bucket.website.arn
        ]
      },
      {
        Sid    = "SNS"
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.notify_reserved_topic.arn,
          aws_sns_topic.notify_left_topic.arn,
          aws_sns_topic.rekognize_alarm_topic.arn
        ]
      },
      {
        Sid    = "LambdaInvoke"
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:team06*"
      },
      {
        Sid    = "Scheduler"
        Effect = "Allow"
        Action = [
          "scheduler:CreateSchedule",
          "scheduler:DeleteSchedule"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMPassRole"
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = aws_iam_role.scheduler_role.arn
      },
      {
        Sid    = "CloudWatchMetrics"
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

# --- IAM Role for EventBridge Scheduler ---

resource "aws_iam_role" "scheduler_role" {
  name = "team06-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project = "team06"
  }
}

resource "aws_iam_role_policy" "scheduler_policy" {
  name = "team06-scheduler-policy"
  role = aws_iam_role.scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          aws_lambda_function.check_and_release_washer.arn,
          aws_lambda_function.delayed_shadow_update.arn
        ]
      }
    ]
  })
}
