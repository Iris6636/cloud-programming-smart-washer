# --- DynamoDB Stream → Lambda Event Source Mappings ---

resource "aws_lambda_event_source_mapping" "washer_status_activate" {
  event_source_arn  = aws_dynamodb_table.washer_status.stream_arn
  function_name     = aws_lambda_function.activate_event.arn
  starting_position = "LATEST"
  batch_size        = 1
  enabled           = true

  depends_on = [aws_iam_role_policy.lambda_policy]
}

resource "aws_lambda_event_source_mapping" "washer_status_end_wash" {
  event_source_arn  = aws_dynamodb_table.washer_status.stream_arn
  function_name     = aws_lambda_function.end_wash_session.arn
  starting_position = "LATEST"
  batch_size        = 1
  enabled           = true

  depends_on = [aws_iam_role_policy.lambda_policy]
}

resource "aws_lambda_event_source_mapping" "washer_status_left_time_alert" {
  event_source_arn  = aws_dynamodb_table.washer_status.stream_arn
  function_name     = aws_lambda_function.notify_left_time.arn
  starting_position = "LATEST"
  batch_size        = 1
  enabled           = true

  depends_on = [aws_iam_role_policy.lambda_policy]
}

# --- Lambda Permission for S3 to invoke Rekognition Lambda ---

resource "aws_lambda_permission" "s3_invoke_rekognize" {
  statement_id  = "AllowS3Invoke-Rekognize"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rekognize_time.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images.arn
}
