resource "aws_cloudwatch_metric_alarm" "tfer--team06_RekognitionFailAlarm" {
  actions_enabled     = "true"
  alarm_actions       = ["arn:aws:sns:us-east-1:701030859948:team06-CloudWatch_RekognitionAlarmNotify"]
  alarm_description   = "此 Alarm 會在 1 分鐘內發生超過 1次 [REKOGNITION_FAIL] log 時觸發。\n用途：偵測洗衣機辨識畫面失敗、鏡頭拍攝錯誤或時間辨識異常。\n\n對應 Lambda：team06_CloudWatch_Alarm_Rekognition_Fail\n對應 SNS Topic：team06-CloudWatch_RekognitionAlarmNotify"
  alarm_name          = "team06_RekognitionFailAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = "1"
  evaluation_periods  = "1"

  metric_query {
    expression  = "SELECT AVG(RekognitionFailCount) FROM SCHEMA(WasherMonitor)"
    id          = "q1"
    label       = "RekognitionFail"
    period      = "60"
    return_data = "true"
  }

  period = "0"

  tags = {
    team06 = "cloudwatch"
  }

  tags_all = {
    team06 = "cloudwatch"
  }

  threshold          = "1"
  treat_missing_data = "notBreaching"
}
