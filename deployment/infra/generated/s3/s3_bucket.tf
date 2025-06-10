resource "aws_s3_bucket" "tfer--team06-times-image" {
  bucket        = "team06-times-image"
  force_destroy = "false"

  grant {
    id          = "ccc13c2e3ffbffbd2f551f540a50849502b189c51f7281203002f834769add6f"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  object_lock_enabled = "false"
  request_payer       = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }

      bucket_key_enabled = "true"
    }
  }

  tags = {
    team06 = "s3_image"
  }

  tags_all = {
    team06 = "s3_image"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "tfer--team06website" {
  bucket        = "team06website"
  force_destroy = "false"

  grant {
    id          = "ccc13c2e3ffbffbd2f551f540a50849502b189c51f7281203002f834769add6f"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  object_lock_enabled = "false"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "arn:aws:s3:::team06website/*",
      "Sid": "PublicReadGetObject"
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }

      bucket_key_enabled = "true"
    }
  }

  tags = {
    team06 = "s3_website"
  }

  tags_all = {
    team06 = "s3_website"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    error_document = "index.html"
    index_document = "index.html"
  }
}
