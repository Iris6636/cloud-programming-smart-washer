resource "aws_lambda_function" "rekognize_time" {
  function_name = "team06-RekognizeTimeAndUpdateDB"
  filename      = "${path.module}/../lambda/team06-RekognizeTimeAndUpdateDB.zip"
  handler       = "team06-RekognizeTimeAndUpdateDB.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 10
}

resource "aws_lambda_function" "notify_reserved" {
  function_name = "team06-SendReservedUserNotification"
  filename      = "${path.module}/../lambda/team06-SendReservedUserNotification.zip"
  handler       = "team06-SendReservedUserNotification.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SendReservedUserNotification = aws_sns_topic.notify_reserved_topic.arn
    }
  }
}

resource "aws_lambda_function" "notify_left_time" {
  function_name = "team06-SendUserLeftTimeAlert"
  filename      = "${path.module}/../lambda/team06-SendUserLeftTimeAlert.zip"
  handler       = "team06-SendUserLeftTimeAlert.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SendUserLeftTimeAlert = aws_sns_topic.notify_left_topic.arn
    }
  }
}
resource "aws_lambda_function" "activate_event" {
  function_name = "team06_ActivateEvent"
  filename      = "${path.module}/../lambda/team06_ActivateEvent.zip"
  handler       = "team06_ActivateEvent.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SCHEDULER_ROLE_ARN = aws_iam_role.scheduler_role.arn
      TARGET_LAMBDA_ARN  = aws_lambda_function.check_and_release_washer.arn
    }
  }
}

resource "aws_lambda_function" "check_and_release_washer" {
  function_name = "team06_CheckAndReleaseWasher"
  filename      = "${path.module}/../lambda/team06_CheckAndReleaseWasher.zip"
  handler       = "team06_CheckAndReleaseWasher.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "delayed_shadow_update" {
  function_name = "team06_DelayedShadowUpdate"
  filename      = "${path.module}/../lambda/team06_DelayedShadowUpdate.zip"
  handler       = "team06_DelayedShadowUpdate.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "end_wash_session" {
  function_name = "team06_EndWashSession"
  filename      = "${path.module}/../lambda/team06_EndWashSession.zip"
  handler       = "team06_EndWashSession.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SCHEDULER_ROLE_ARN = aws_iam_role.scheduler_role.arn
      TARGET_LAMBDA_ARN  = aws_lambda_function.delayed_shadow_update.arn
    }
  }
}

resource "aws_lambda_function" "finish_wash" {
  function_name = "team06_FinishWash"
  filename      = "${path.module}/../lambda/team06_FinishWash.zip"
  handler       = "team06_FinishWash.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "handle_end_request_unlock_washer" {
  function_name = "team06_HandleEndRequest_UnlockWasher"
  filename      = "${path.module}/../lambda/team06_HandleEndRequest_UnlockWasher.zip"
  handler       = "team06_HandleEndRequest_UnlockWasher.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      CORS_ORIGIN = local.s3_website_origin
    }
  }
}

resource "aws_lambda_function" "handle_reserve_request" {
  function_name = "team06_HandleReserveRequest"
  filename      = "${path.module}/../lambda/team06_HandleReserveRequest.zip"
  handler       = "team06_HandleReserveRequest.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      CORS_ORIGIN = local.s3_website_origin
    }
  }
}

resource "aws_lambda_function" "handle_use_request_no_reservation" {
  function_name = "team06_HandleUseRequest_NoReservation"
  filename      = "${path.module}/../lambda/team06_HandleUseRequest_NoReservation.zip"
  handler       = "team06_HandleUseRequest_NoReservation.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      CORS_ORIGIN = local.s3_website_origin
    }
  }
}

resource "aws_lambda_function" "handle_use_request_with_reservation" {
  function_name = "team06_HandleUseRequest_WithReservation"
  filename      = "${path.module}/../lambda/team06_HandleUseRequest_WithReservation.zip"
  handler       = "team06_HandleUseRequest_WithReservation.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      CORS_ORIGIN = local.s3_website_origin
    }
  }
}

resource "aws_lambda_function" "start_wash" {
  function_name = "team06_StartWash"
  filename      = "${path.module}/../lambda/team06_StartWash.zip"
  handler       = "team06_StartWash.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "washer_has_locked" {
  function_name = "team06_WasherHasLocked"
  filename      = "${path.module}/../lambda/team06_WasherHasLocked.zip"
  handler       = "team06_WasherHasLocked.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "washer_has_unlocked" {
  function_name = "team06_WasherHasUnlocked"
  filename      = "${path.module}/../lambda/team06_WasherHasUnlocked.zip"
  handler       = "team06_WasherHasUnlocked.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "v2_base64_to_s3" {
  function_name    = "team06_V2base64toS3"
  filename         = "${path.module}/../lambda/team06_V2base64toS3.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/team06_V2base64toS3.zip")
  handler          = "team06_V2base64toS3.lambda_handler"
  runtime          = "python3.13"
  role             = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      S3_BUCKET_IMAGES = var.s3_bucket_images
    }
  }
}

resource "aws_lambda_function" "upload" {
  function_name = "team06_upload"
  filename      = "${path.module}/../lambda/team06_upload.zip"
  handler       = "team06_upload.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "cloudwatch_alarm_rekognition_fail" {
  function_name = "team06_CloudWatch_Alarm_Rekognition_Fail"
  filename      = "${path.module}/../lambda/team06_CloudWatch_Alarm_Rekognition_Fail.zip"
  handler       = "team06_CloudWatch_Alarm_Rekognition_Fail.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "express" {
  function_name    = "team06-express"
  filename         = "${path.module}/../lambda/express.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/express.zip")
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 15
  memory_size      = 128

  environment {
    variables = {
      COGNITO_USER_POOL_ID = aws_cognito_user_pool.team06.id
      COGNITO_CLIENT_ID    = aws_cognito_user_pool_client.team06.id
      CORS_ORIGIN          = local.s3_website_origin
    }
  }

  tags = {
    team06 = "express"
  }
}
