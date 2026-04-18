# --- CloudWatch Metric Alarm: Rekognition Failure ---

resource "aws_cloudwatch_metric_alarm" "rekognition_fail" {
  alarm_name          = "team06_RekognitionFailAlarm"
  alarm_description   = "Alarm triggers when Rekognition fails more than 1 time in 1 minute. Detects washer display recognition failures."
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rekognize_alarm_topic.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 1
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "q1"
    expression  = "SELECT AVG(RekognitionFailCount) FROM SCHEMA(WasherMonitor)"
    label       = "RekognitionFail"
    period      = 60
    return_data = true
  }

  tags = {
    team06 = "cloudwatch"
  }
}

# --- CloudWatch Logs Metric Filter: Rekognition Failure ---

resource "aws_cloudwatch_log_metric_filter" "rekognition_fail" {
  name           = "team06-RekognitionFailFilter"
  log_group_name = "/aws/lambda/team06-RekognizeTimeAndUpdateDB"
  pattern        = "[REKOGNITION_FAIL]"

  metric_transformation {
    name          = "RekognitionFailCount"
    namespace     = "WasherMonitor"
    value         = "1"
    default_value = "0"
  }
}
