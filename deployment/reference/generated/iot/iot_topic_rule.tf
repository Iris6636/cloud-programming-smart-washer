resource "aws_iot_topic_rule" "tfer--team06_CaptureImageToS3Rule" {
  enabled = "true"

  lambda {
    function_arn = "arn:aws:lambda:us-east-1:701030859948:function:team06_V2base64toS3"
  }

  name        = "team06_CaptureImageToS3Rule"
  sql         = "SELECT * FROM 'device/camera/image'"
  sql_version = "2015-10-08"

  tags = {
    team06 = "iot"
  }

  tags_all = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "tfer--team06_EndWash_Unlock" {
  description = "Washer has unlocked since user press end session(unlock) button"
  enabled     = "true"

  lambda {
    function_arn = "arn:aws:lambda:us-east-1:701030859948:function:team06_EndWashSession"
  }

  lambda {
    function_arn = "arn:aws:lambda:us-east-1:701030859948:function:team06_WasherHasUnlocked"
  }

  name        = "team06_EndWash_Unlock"
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.door_locked = false AND previous.state.reported.door_locked = true AND current.state.reported.unlock_reason = 'end_wash'"
  sql_version = "2016-03-23"

  tags = {
    team06 = "iot"
  }

  tags_all = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "tfer--team06_FinishWashing" {
  description = "If vibration = false, trigger Lambda(FinishWash)"
  enabled     = "true"

  lambda {
    function_arn = "arn:aws:lambda:us-east-1:701030859948:function:team06_FinishWash"
  }

  name        = "team06_FinishWashing"
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.vibration_detected = false AND previous.state.reported.vibration_detected = true"
  sql_version = "2016-03-23"

  tags = {
    team06 = "iot"
  }

  tags_all = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "tfer--team06_LockWasher" {
  description = "If door_locked = true, trigger Lambda(WasherHasLocked)"
  enabled     = "true"

  lambda {
    function_arn = "arn:aws:lambda:us-east-1:701030859948:function:team06_WasherHasLocked"
  }

  name        = "team06_LockWasher"
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.door_locked = true AND previous.state.reported.door_locked = false"
  sql_version = "2016-03-23"

  tags = {
    team06 = "iot"
  }

  tags_all = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "tfer--team06_Reserved_Unlock" {
  description = "Washer unlocked when reserved user press use button or reservation has expired"
  enabled     = "true"

  lambda {
    function_arn = "arn:aws:lambda:us-east-1:701030859948:function:team06_WasherHasUnlocked"
  }

  name        = "team06_Reserved_Unlock"
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.door_locked = false AND previous.state.reported.door_locked = true AND current.state.reported.unlock_reason = 'reserve_related'"
  sql_version = "2016-03-23"

  tags = {
    team06 = "iot"
  }

  tags_all = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "tfer--team06_SendCameraImageToLambda" {
  enabled     = "true"
  name        = "team06_SendCameraImageToLambda"
  sql         = "SELECT * FROM 'device/camera/image'"
  sql_version = "2015-10-08"

  tags = {
    team06 = "iot"
  }

  tags_all = {
    team06 = "iot"
  }
}

resource "aws_iot_topic_rule" "tfer--team06_StartWashing" {
  description = "If vibration = true, trigger Lambda(StartWash)"
  enabled     = "true"

  lambda {
    function_arn = "arn:aws:lambda:us-east-1:701030859948:function:team06_StartWash"
  }

  name        = "team06_StartWashing"
  sql         = "SELECT current.state.reported.washer_id as washer_id FROM '$aws/things/team06_IoT/shadow/update/documents' WHERE current.state.reported.vibration_detected = true AND previous.state.reported.vibration_detected = false"
  sql_version = "2016-03-23"

  tags = {
    team06 = "iot"
  }

  tags_all = {
    team06 = "iot"
  }
}
