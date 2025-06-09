resource "aws_sns_topic" "notify_reserved_topic" {
  name = "team06-SendReservedUserNotification"
}

resource "aws_sns_topic" "notify_left_topic" {
  name = "team06-SendUserLeftTimeAlert"
}

resource "aws_sns_topic" "rekognize_alarm_topic" {
  name = "team06-RekognitionAlarmNotify"
}

resource "aws_sns_topic_subscription" "notify_reserved_subscription" {
  topic_arn = aws_sns_topic.notify_reserved_topic.arn
  protocol  = "email"
  endpoint  = "thpss93214@gmail.com"
  filter_policy = jsonencode({
    user_email_address = ["thpss93214@gmail.com"]
  })
}

resource "aws_sns_topic_subscription" "notify_left_subscription" {
  topic_arn = aws_sns_topic.notify_left_topic.arn
  protocol  = "email"
  endpoint  = "thpss93214@gmail.com"
  filter_policy = jsonencode({
    user_email_address = ["thpss93214@gmail.com"]
  })
}

resource "aws_sns_topic_subscription" "rekognize_alarm_subscription" {
  topic_arn = aws_sns_topic.rekognize_alarm_topic.arn
  protocol  = "email"
  endpoint  = "thpss93214@gmail.com"
  # 無 filter policy
}