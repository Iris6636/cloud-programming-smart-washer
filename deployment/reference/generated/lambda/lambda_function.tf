resource "aws_lambda_function" "tfer--team06-RekognizeTimeAndUpdateDB" {
  architectures = ["x86_64"]
  description   = "Detects remaining time from S3 image and updates DynamoDB \"WasherStatus-time\""

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06-RekognizeTimeAndUpdateDB"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06-RekognizeTimeAndUpdateDB"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "10"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06-SendReservedUserNotification" {
  architectures = ["x86_64"]
  description   = "Triggered by EndWashSession Lambda. Sends an email to the user who reserved the washer."

  environment {
    variables = {
      SendReservedUserNotification = "arn:aws:sns:us-east-1:701030859948:team06-SendReservedUserNotification"
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06-SendReservedUserNotification"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06-SendReservedUserNotification"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06-SendUserLeftTimeAlert" {
  architectures = ["x86_64"]
  description   = "Triggered when washer time is 3 or 0. Sends alert email to the current user."

  environment {
    variables = {
      SendUserLeftTimeAlert = "arn:aws:sns:us-east-1:701030859948:team06-SendUserLeftTimeAlert"
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06-SendUserLeftTimeAlert"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06-SendUserLeftTimeAlert"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06-express" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06-express"
  handler       = "index.handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06-express"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "nodejs22.x"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_ActivateEvent" {
  architectures = ["x86_64"]
  description   = "If Table WashStatus has changed, DynamoDB stream will trigger this function(will activate Event Bridge if needed)"

  environment {
    variables = {
      SCHEDULER_ROLE_ARN = "arn:aws:iam::701030859948:role/LabRole"
      TARGET_LAMBDA_ARN  = "arn:aws:lambda:us-east-1:701030859948:function:team06_CheckAndReleaseWasher"
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_ActivateEvent"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_ActivateEvent"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_CheckAndReleaseWasher" {
  architectures = ["x86_64"]
  description   = "Event Bridge will trigger this function to check expire_at"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_CheckAndReleaseWasher"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_CheckAndReleaseWasher"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_CloudWatch_Alarm_Rekognition_Fail" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_CloudWatch_Alarm_Rekognition_Fail"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_CloudWatch_Alarm_Rekognition_Fail"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.11"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_DelayedShadowUpdate" {
  architectures = ["x86_64"]
  description   = "Triggered by EndWashSession to update shadow"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_DelayedShadowUpdate"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_DelayedShadowUpdate"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_EndWashSession" {
  architectures = ["x86_64"]
  description   = "After user press unlock button and washer unlocked, IoT Rule will trigger this function to update DB \u0026 find reservation"

  environment {
    variables = {
      SCHEDULER_ROLE_ARN = "arn:aws:iam::701030859948:role/LabRole"
      TARGET_LAMBDA_ARN  = "arn:aws:lambda:us-east-1:701030859948:function:team06_DelayedShadowUpdate"
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_EndWashSession"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_EndWashSession"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_FinishWash" {
  architectures = ["x86_64"]
  description   = "If vibration = false, IoT Rule will trigger this function to update DB \u0026 shadow"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_FinishWash"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_FinishWash"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_HandleEndRequest_UnlockWasher" {
  architectures = ["x86_64"]
  description   = "If user press unlock button on website, API Gateway will trigger this function to update DB \u0026 shadow"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_HandleEndRequest_UnlockWasher"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_HandleEndRequest_UnlockWasher"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_HandleReserveRequest" {
  architectures = ["x86_64"]
  description   = "If user press reserve button on website, API Gateway will trigger this function to update reserve status in DB"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_HandleReserveRequest"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_HandleReserveRequest"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_HandleUseRequest_NoReservation" {
  architectures = ["x86_64"]
  description   = "If user who didn't reserve press use button on website, API Gateway will trigger this function to update DB"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_HandleUseRequest_NoReservation"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_HandleUseRequest_NoReservation"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_HandleUseRequest_WithReservation" {
  architectures = ["x86_64"]
  description   = "If user who has reserved press use button on website, API Gateway will trigger this function to update DB \u0026 shadow"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_HandleUseRequest_WithReservation"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_HandleUseRequest_WithReservation"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_StartWash" {
  architectures = ["x86_64"]
  description   = "If vibration = true, IoT Rule will trigger this function to update DB \u0026 shadow"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_StartWash"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_StartWash"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_V2base64toS3" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_V2base64toS3"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_V2base64toS3"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_WasherHasLocked" {
  architectures = ["x86_64"]
  description   = "If door_locked = true, IoT Rule willl trigger this function to update DB"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_WasherHasLocked"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_WasherHasLocked"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_WasherHasUnlocked" {
  architectures = ["x86_64"]
  description   = "If door_locked = false, IoT Rule will trigger this function to update DB"

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_WasherHasUnlocked"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_WasherHasUnlocked"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_function" "tfer--team06_upload" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "team06_upload"
  handler       = "lambda_function.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/team06_upload"
  }

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::701030859948:role/LabRole"
  runtime                        = "python3.13"
  skip_destroy                   = "false"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  timeout = "3"

  tracing_config {
    mode = "PassThrough"
  }
}
