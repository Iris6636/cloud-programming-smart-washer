# --- Cognito User Pool ---

resource "aws_cognito_user_pool" "team06" {
  name                     = "team06-UserPool"
  deletion_protection      = "ACTIVE"
  mfa_configuration        = "OFF"
  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length                   = 8
    password_history_size            = 0
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  sign_in_policy {
    allowed_first_auth_factors = ["PASSWORD"]
  }

  user_pool_tier = "ESSENTIALS"

  username_configuration {
    case_sensitive = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  tags = {
    team06 = "cognito"
  }
}

# --- Cognito User Pool Client ---

resource "aws_cognito_user_pool_client" "team06" {
  name         = "team06-WebClient"
  user_pool_id = aws_cognito_user_pool.team06.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  generate_secret = false
}
