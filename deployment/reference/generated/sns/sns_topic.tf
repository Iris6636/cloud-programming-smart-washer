resource "aws_sns_topic" "tfer--team06-CloudWatch_RekognitionAlarmNotify" {
  application_success_feedback_sample_rate = "0"
  content_based_deduplication              = "false"
  fifo_topic                               = "false"
  firehose_success_feedback_sample_rate    = "0"
  http_success_feedback_sample_rate        = "0"
  lambda_success_feedback_sample_rate      = "0"
  name                                     = "team06-CloudWatch_RekognitionAlarmNotify"

  policy = <<POLICY
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "701030859948"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "arn:aws:sns:us-east-1:701030859948:team06-CloudWatch_RekognitionAlarmNotify",
      "Sid": "__default_statement_ID"
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  signature_version                = "0"
  sqs_success_feedback_sample_rate = "0"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }
}

resource "aws_sns_topic" "tfer--team06-SendReservedUserNotification" {
  application_success_feedback_sample_rate = "0"
  content_based_deduplication              = "false"
  display_name                             = "WasherNotifier"
  fifo_topic                               = "false"
  firehose_success_feedback_sample_rate    = "0"
  http_success_feedback_sample_rate        = "0"
  lambda_success_feedback_sample_rate      = "0"
  name                                     = "team06-SendReservedUserNotification"

  policy = <<POLICY
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "701030859948"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "arn:aws:sns:us-east-1:701030859948:team06-SendReservedUserNotification",
      "Sid": "__default_statement_ID"
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  signature_version                = "0"
  sqs_success_feedback_sample_rate = "0"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  tracing_config = "PassThrough"
}

resource "aws_sns_topic" "tfer--team06-SendUserLeftTimeAlert" {
  application_success_feedback_sample_rate = "0"
  content_based_deduplication              = "false"
  display_name                             = "WasherNotifier"
  fifo_topic                               = "false"
  firehose_success_feedback_sample_rate    = "0"
  http_success_feedback_sample_rate        = "0"
  lambda_success_feedback_sample_rate      = "0"
  name                                     = "team06-SendUserLeftTimeAlert"

  policy = <<POLICY
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "701030859948"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "arn:aws:sns:us-east-1:701030859948:team06-SendUserLeftTimeAlert",
      "Sid": "__default_statement_ID"
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  signature_version                = "0"
  sqs_success_feedback_sample_rate = "0"

  tags = {
    team06 = "110062310"
  }

  tags_all = {
    team06 = "110062310"
  }

  tracing_config = "PassThrough"
}
