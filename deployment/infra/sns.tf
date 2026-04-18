resource "aws_sns_topic" "notify_reserved_topic" {
  name         = "team06-SendReservedUserNotification"
  display_name = "WasherNotifier"
}

resource "aws_sns_topic" "notify_left_topic" {
  name         = "team06-SendUserLeftTimeAlert"
  display_name = "WasherNotifier"
}

resource "aws_sns_topic" "rekognize_alarm_topic" {
  name = "team06-CloudWatch_RekognitionAlarmNotify"
}

resource "aws_sns_topic_subscription" "notify_reserved_subscription" {
  topic_arn = aws_sns_topic.notify_reserved_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
  filter_policy = jsonencode({
    user_email_address = [var.notification_email]
  })
}

resource "aws_sns_topic_subscription" "notify_left_subscription" {
  topic_arn = aws_sns_topic.notify_left_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
  filter_policy = jsonencode({
    user_email_address = [var.notification_email]
  })
}

resource "aws_sns_topic_subscription" "rekognize_alarm_subscription" {
  topic_arn = aws_sns_topic.rekognize_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
