# --- IoT Endpoint (for MQTT connections) ---

data "aws_iot_endpoint" "current" {
  endpoint_type = "iot:Data-ATS"
}

# --- IoT Thing ---

resource "aws_iot_thing" "team06_iot" {
  name = "team06_IoT"
}

# --- IoT Topic Rules ---

resource "aws_iot_topic_rule" "start_washing" {
  name        = "team06_StartWashing"
  description = "If vibration = true, trigger Lambda(StartWash)"
  enabled     = true
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.vibration_detected = true AND previous.state.reported.vibration_detected = false"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.start_wash.arn
  }

  tags = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "finish_washing" {
  name        = "team06_FinishWashing"
  description = "If vibration = false, trigger Lambda(FinishWash)"
  enabled     = true
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.vibration_detected = false AND previous.state.reported.vibration_detected = true"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.finish_wash.arn
  }

  tags = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "lock_washer" {
  name        = "team06_LockWasher"
  description = "If door_locked = true, trigger Lambda(WasherHasLocked)"
  enabled     = true
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.door_locked = true AND previous.state.reported.door_locked = false"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.washer_has_locked.arn
  }

  tags = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "end_wash_unlock" {
  name        = "team06_EndWash_Unlock"
  description = "Washer has unlocked since user press end session(unlock) button"
  enabled     = true
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.door_locked = false AND previous.state.reported.door_locked = true AND current.state.reported.unlock_reason = 'end_wash'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.end_wash_session.arn
  }

  lambda {
    function_arn = aws_lambda_function.washer_has_unlocked.arn
  }

  tags = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "reserved_unlock" {
  name        = "team06_Reserved_Unlock"
  description = "Washer unlocked when reserved user press use button or reservation has expired"
  enabled     = true
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.door_locked = false AND previous.state.reported.door_locked = true AND current.state.reported.unlock_reason = 'reserve_related'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.washer_has_unlocked.arn
  }

  tags = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "capture_image" {
  name        = "team06_CaptureImageToS3Rule"
  description = "Capture camera image and send to Lambda for S3 upload"
  enabled     = true
  sql         = "SELECT * FROM 'device/camera/image'"
  sql_version = "2015-10-08"

  lambda {
    function_arn = aws_lambda_function.v2_base64_to_s3.arn
  }

  tags = {
    team06 = "iot"
  }
}

# --- Lambda Permissions for IoT Rules ---

resource "aws_lambda_permission" "iot_start_wash" {
  statement_id  = "AllowIoTInvoke-StartWash"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_wash.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.start_washing.arn
}

resource "aws_lambda_permission" "iot_finish_wash" {
  statement_id  = "AllowIoTInvoke-FinishWash"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.finish_wash.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.finish_washing.arn
}

resource "aws_lambda_permission" "iot_washer_locked" {
  statement_id  = "AllowIoTInvoke-WasherLocked"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.washer_has_locked.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.lock_washer.arn
}

resource "aws_lambda_permission" "iot_end_wash_unlock_session" {
  statement_id  = "AllowIoTInvoke-EndWashSession"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.end_wash_session.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.end_wash_unlock.arn
}

resource "aws_lambda_permission" "iot_end_wash_unlock_unlocked" {
  statement_id  = "AllowIoTInvoke-WasherUnlocked-EndWash"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.washer_has_unlocked.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.end_wash_unlock.arn
}

resource "aws_lambda_permission" "iot_reserved_unlock" {
  statement_id  = "AllowIoTInvoke-WasherUnlocked-Reserved"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.washer_has_unlocked.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.reserved_unlock.arn
}

resource "aws_lambda_permission" "iot_capture_image" {
  statement_id  = "AllowIoTInvoke-CaptureImage"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.v2_base64_to_s3.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.capture_image.arn
}

# --- IoT Policy ---

resource "aws_iot_policy" "team06_device_policy" {
  name = "team06-DevicePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iot:Connect"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iot:Publish",
          "iot:Receive"
        ]
        Resource = [
          "arn:aws:iot:${var.aws_region}:${data.aws_caller_identity.current.account_id}:topic/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "iot:Subscribe"
        Resource = "arn:aws:iot:${var.aws_region}:${data.aws_caller_identity.current.account_id}:topicfilter/*"
      },
      {
        Effect = "Allow"
        Action = [
          "iot:UpdateThingShadow",
          "iot:GetThingShadow"
        ]
        Resource = "arn:aws:iot:${var.aws_region}:${data.aws_caller_identity.current.account_id}:thing/team06_IoT"
      }
    ]
  })
}
