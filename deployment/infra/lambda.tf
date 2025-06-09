resource "aws_lambda_function" "rekognize_time" {
  function_name = "team06-RekognizeTimeAndUpdateDB"
  filename      = "${path.module}/../lambda/team06-RekognizeTimeAndUpdateDB.zip"
  handler       = "team06-RekognizeTimeAndUpdateDB.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "notify_reserved" {
  function_name = "team06-SendReservedUserNotification"
  filename      = "${path.module}/../lambda/team06-SendReservedUserNotification.zip"
  handler       = "team06-SendReservedUserNotification.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.user_notifications.arn
    }
  }
}

resource "aws_lambda_function" "notify_left_time" {
  function_name = "team06-SendUserLeftTimeAlert"
  filename      = "${path.module}/../lambda/team06-SendUserLeftTimeAlert.zip"
  handler       = "team06-SendUserLeftTimeAlert.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}



# Update
resource "aws_lambda_function" "activate_event" {
  function_name = "team06_ActivateEvent"
  filename      = "${path.module}/../lambda/team06_ActivateEvent.zip"
  handler       = "team06_ActivateEvent.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SCHEDULER_ROLE_ARN = aws_iam_role.lambda_exec.arn
      TARGET_LAMBDA_ARN  = aws_lambda_function.check_and_release_washer.arn
    }
  }
}

resource "aws_lambda_function" "check_and_release_washer" {
  function_name = "team06_CheckAndReleaseWasher"
  filename      = "${path.module}/../lambda/team06_CheckAndReleaseWasher.zip"
  handler       = "team06_CheckAndReleaseWasher.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "delayed_shadow_update" {
  function_name = "team06_DelayedShadowUpdate"
  filename      = "${path.module}/../lambda/team06_DelayedShadowUpdate.zip"
  handler       = "team06_DelayedShadowUpdate.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "end_wash_session" {
  function_name = "team06_EndWashSession"
  filename      = "${path.module}/../lambda/team06_EndWashSession.zip"
  handler       = "team06_EndWashSession.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      SCHEDULER_ROLE_ARN = aws_iam_role.lambda_exec.arn
      TARGET_LAMBDA_ARN  = aws_lambda_function.delayed_shadow_update.arn
    }
  }
}

resource "aws_lambda_function" "finish_wash" {
  function_name = "team06_FinishWash"
  filename      = "${path.module}/../lambda/team06_FinishWash.zip"
  handler       = "team06_FinishWash.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "handle_end_request_unlock_washer" {
  function_name = "team06_HandleEndRequest_UnlockWasher"
  filename      = "${path.module}/../lambda/team06_HandleEndRequest_UnlockWasher.zip"
  handler       = "team06_HandleEndRequest_UnlockWasher.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "handle_reserve_request" {
  function_name = "team06_HandleReserveRequest"
  filename      = "${path.module}/../lambda/team06_HandleReserveRequest.zip"
  handler       = "team06_HandleReserveRequest.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "handle_use_request_no_reservation" {
  function_name = "team06_HandleUseRequest_NoReservation"
  filename      = "${path.module}/../lambda/team06_HandleUseRequest_NoReservation.zip"
  handler       = "team06_HandleUseRequest_NoReservation.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "handle_use_request_with_reservation" {
  function_name = "team06_HandleUseRequest_WithReservation"
  filename      = "${path.module}/../lambda/team06_HandleUseRequest_WithReservation.zip"
  handler       = "team06_HandleUseRequest_WithReservation.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "start_wash" {
  function_name = "team06_StartWash"
  filename      = "${path.module}/../lambda/team06_StartWash.zip"
  handler       = "team06_StartWash.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "washer_has_locked" {
  function_name = "team06_WasherHasLocked"
  filename      = "${path.module}/../lambda/team06_WasherHasLocked.zip"
  handler       = "team06_WasherHasLocked.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "washer_has_unlocked" {
  function_name = "team06_WasherHasUnlocked"
  filename      = "${path.module}/../lambda/team06_WasherHasUnlocked.zip"
  handler       = "team06_WasherHasUnlocked.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}
