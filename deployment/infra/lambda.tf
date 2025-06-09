resource "aws_lambda_function" "rekognize_time" {
  function_name = "team06-RekognizeTimeAndUpdateDB"
  filename      = "${path.module}/../lambda/team06-RekognizeTimeAndUpdateDB.zip"
  handler       = "team06-RekognizeTimeAndUpdateDB.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "notify_reserved" {
  function_name = "team06-SendReservedUserNotification"
  filename      = "${path.module}/../lambda/team06-SendReservedUserNotification.zip"
  handler       = "team06-SendReservedUserNotification.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.user_notifications.arn
    }
  }
}

resource "aws_lambda_function" "notify_left_time" {
  function_name = "team06-SendUserLeftTimeAlert"
  filename      = "${path.module}/../lambda/team06-SendUserLeftTimeAlert.zip"
  handler       = "team06-SendUserLeftTimeAlert.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}