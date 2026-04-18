# --- Outputs ---

output "api_gateway_invoke_url" {
  description = "API Gateway base URL for the team06-iot-api"
  value       = "${aws_api_gateway_stage.prod.invoke_url}"
}

output "express_api_invoke_url" {
  description = "API Gateway base URL for the team06-express API"
  value       = "${aws_api_gateway_stage.express_prod.invoke_url}"
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.team06.id
}

output "cognito_client_id" {
  description = "Cognito User Pool Client ID"
  value       = aws_cognito_user_pool_client.team06.id
}

output "s3_website_endpoint" {
  description = "S3 static website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

output "s3_bucket_images" {
  description = "S3 bucket name for washer images"
  value       = aws_s3_bucket.images.bucket
}

output "sns_topic_reserved_notification" {
  description = "SNS Topic ARN for reserved user notifications"
  value       = aws_sns_topic.notify_reserved_topic.arn
}

output "sns_topic_left_time_alert" {
  description = "SNS Topic ARN for left time alerts"
  value       = aws_sns_topic.notify_left_topic.arn
}

output "sns_topic_rekognition_alarm" {
  description = "SNS Topic ARN for Rekognition alarm"
  value       = aws_sns_topic.rekognize_alarm_topic.arn
}

output "iot_thing_name" {
  description = "IoT Thing name"
  value       = aws_iot_thing.team06_iot.name
}

output "iot_endpoint" {
  description = "IoT Core data endpoint (for MQTT connections)"
  value       = data.aws_iot_endpoint.current.endpoint_address
}

output "scheduler_role_arn" {
  description = "EventBridge Scheduler IAM Role ARN"
  value       = aws_iam_role.scheduler_role.arn
}
