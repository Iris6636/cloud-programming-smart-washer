# --- API Gateway: team06-iot-api ---

locals {
  s3_website_url = "http://${aws_s3_bucket.website.bucket}.s3-website-${var.aws_region}.amazonaws.com"

  api_endpoints = {
    use = {
      path_part   = "use"
      lambda_func = aws_lambda_function.handle_use_request_no_reservation
    }
    use_reserved = {
      path_part   = "use_reserved"
      lambda_func = aws_lambda_function.handle_use_request_with_reservation
    }
    reserve = {
      path_part   = "reserve"
      lambda_func = aws_lambda_function.handle_reserve_request
    }
    unlock = {
      path_part   = "unlock"
      lambda_func = aws_lambda_function.handle_end_request_unlock_washer
    }
  }
}

resource "aws_api_gateway_rest_api" "team06_iot_api" {
  name = "team06-iot-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    team06 = "iot_api"
  }
}

# --- Cognito Authorizer ---

resource "aws_api_gateway_authorizer" "team06_auth" {
  name            = "team06_Auth"
  rest_api_id     = aws_api_gateway_rest_api.team06_iot_api.id
  type            = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"
  provider_arns   = [aws_cognito_user_pool.team06.arn]
}

# --- API Resources (paths) ---

resource "aws_api_gateway_resource" "endpoints" {
  for_each    = local.api_endpoints
  rest_api_id = aws_api_gateway_rest_api.team06_iot_api.id
  parent_id   = aws_api_gateway_rest_api.team06_iot_api.root_resource_id
  path_part   = each.value.path_part
}

# --- POST Methods (with Cognito auth) ---

resource "aws_api_gateway_method" "post" {
  for_each      = local.api_endpoints
  rest_api_id   = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id   = aws_api_gateway_resource.endpoints[each.key].id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.team06_auth.id
}

resource "aws_api_gateway_integration" "post" {
  for_each                = local.api_endpoints
  rest_api_id             = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id             = aws_api_gateway_resource.endpoints[each.key].id
  http_method             = aws_api_gateway_method.post[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = each.value.lambda_func.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
}

# --- POST Method Response (200 with CORS) ---

resource "aws_api_gateway_method_response" "post_200" {
  for_each    = local.api_endpoints
  rest_api_id = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id = aws_api_gateway_resource.endpoints[each.key].id
  http_method = aws_api_gateway_method.post[each.key].http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }

  depends_on = [aws_api_gateway_integration.post]
}

# --- POST Integration Response (200 with CORS origin) ---

resource "aws_api_gateway_integration_response" "post_200" {
  for_each    = local.api_endpoints
  rest_api_id = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id = aws_api_gateway_resource.endpoints[each.key].id
  http_method = aws_api_gateway_method.post[each.key].http_method
  status_code = aws_api_gateway_method_response.post_200[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'${local.s3_website_url}'"
  }

  depends_on = [aws_api_gateway_integration.post]
}

# --- OPTIONS Methods (CORS preflight) ---

resource "aws_api_gateway_method" "options" {
  for_each      = local.api_endpoints
  rest_api_id   = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id   = aws_api_gateway_resource.endpoints[each.key].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  for_each    = local.api_endpoints
  rest_api_id = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id = aws_api_gateway_resource.endpoints[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_200" {
  for_each    = local.api_endpoints
  rest_api_id = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id = aws_api_gateway_resource.endpoints[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_integration_response" "options_200" {
  for_each    = local.api_endpoints
  rest_api_id = aws_api_gateway_rest_api.team06_iot_api.id
  resource_id = aws_api_gateway_resource.endpoints[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  status_code = aws_api_gateway_method_response.options_200[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${local.s3_website_url}'"
  }

  depends_on = [aws_api_gateway_integration.options]
}

# --- Deployment & Stage ---

resource "aws_api_gateway_deployment" "team06_iot_api" {
  rest_api_id = aws_api_gateway_rest_api.team06_iot_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.endpoints,
      aws_api_gateway_method.post,
      aws_api_gateway_integration.post,
      aws_api_gateway_method_response.post_200,
      aws_api_gateway_integration_response.post_200,
      aws_api_gateway_method.options,
      aws_api_gateway_integration.options,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.post,
    aws_api_gateway_integration.options,
    aws_api_gateway_integration_response.post_200,
  ]
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.team06_iot_api.id
  deployment_id = aws_api_gateway_deployment.team06_iot_api.id
  stage_name    = "prod"

  tags = {
    team06 = "iot_api"
  }
}

# --- Lambda Permissions for API Gateway ---

resource "aws_lambda_permission" "api_gateway" {
  for_each      = local.api_endpoints
  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.team06_iot_api.execution_arn}/*/${aws_api_gateway_method.post[each.key].http_method}/${each.value.path_part}"
}

# --- Gateway Response for CORS on 4XX/5XX ---

resource "aws_api_gateway_gateway_response" "cors_4xx" {
  rest_api_id   = aws_api_gateway_rest_api.team06_iot_api.id
  response_type = "DEFAULT_4XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'${local.s3_website_url}'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
  }
}

resource "aws_api_gateway_gateway_response" "cors_5xx" {
  rest_api_id   = aws_api_gateway_rest_api.team06_iot_api.id
  response_type = "DEFAULT_5XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'${local.s3_website_url}'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
  }
}
