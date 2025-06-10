resource "aws_dynamodb_table" "tfer--team06-UserInfo" {
  attribute {
    name = "user_id"
    type = "S"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "user_id"
  name                        = "team06-UserInfo"

  point_in_time_recovery {
    enabled                 = "false"
    recovery_period_in_days = "0"
  }

  read_capacity  = "0"
  stream_enabled = "false"
  table_class    = "STANDARD"

  tags = {
    team06 = "db_user"
  }

  tags_all = {
    team06 = "db_user"
  }

  write_capacity = "0"
}

resource "aws_dynamodb_table" "tfer--team06-WasherStatus" {
  attribute {
    name = "washer_id"
    type = "N"
  }

  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = "false"
  hash_key                    = "washer_id"
  name                        = "team06-WasherStatus"

  point_in_time_recovery {
    enabled                 = "false"
    recovery_period_in_days = "0"
  }

  read_capacity    = "0"
  stream_enabled   = "true"
  stream_view_type = "NEW_IMAGE"
  table_class      = "STANDARD"

  tags = {
    Team   = "06"
    team06 = "washer_db"
  }

  tags_all = {
    Team   = "06"
    team06 = "washer_db"
  }

  write_capacity = "0"
}
