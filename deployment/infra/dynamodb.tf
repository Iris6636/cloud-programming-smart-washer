resource "aws_dynamodb_table" "washer_status" {
  name           = "team06-WasherStatus"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "washer_id"

  attribute {
    name = "washer_id"
    type = "N"
  }

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  tags = {
    Project     = "team06"
    Environment = "prod"
  }
}


resource "aws_dynamodb_table" "user_info" {
  name           = "team06-UserInfo"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Project     = "team06"
    Environment = "prod"
  }
}
