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
