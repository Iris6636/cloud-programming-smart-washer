# --- API Gateway: team06-express ---
# Express.js Lambda proxy API for /washer, /user, /item endpoints

resource "aws_api_gateway_rest_api" "express_api" {
  name = "team06-express"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    team06 = "express_api"
  }
}

# --- Cognito Authorizer ---

resource "aws_api_gateway_authorizer" "express_auth" {
  name            = "Express_Auth"
  rest_api_id     = aws_api_gateway_rest_api.express_api.id
  type            = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"
  provider_arns   = [aws_cognito_user_pool.team06.arn]
}

# --- Root "/" ANY method with AWS_IAM auth ---

resource "aws_api_gateway_method" "express_root_any" {
  rest_api_id   = aws_api_gateway_rest_api.express_api.id
  resource_id   = aws_api_gateway_rest_api.express_api.root_resource_id
  http_method   = "ANY"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "express_root_any" {
  rest_api_id             = aws_api_gateway_rest_api.express_api.id
  resource_id             = aws_api_gateway_rest_api.express_api.root_resource_id
  http_method             = aws_api_gateway_method.express_root_any.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.express.invoke_arn
}

# --- Proxy Resource {proxy+} ---

resource "aws_api_gateway_resource" "express_proxy" {
  rest_api_id = aws_api_gateway_rest_api.express_api.id
  parent_id   = aws_api_gateway_rest_api.express_api.root_resource_id
  path_part   = "{proxy+}"
}

# --- ANY method on {proxy+} with Cognito auth ---

resource "aws_api_gateway_method" "express_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.express_api.id
  resource_id   = aws_api_gateway_resource.express_proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.express_auth.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "express_proxy_any" {
  rest_api_id             = aws_api_gateway_rest_api.express_api.id
  resource_id             = aws_api_gateway_resource.express_proxy.id
  http_method             = aws_api_gateway_method.express_proxy_any.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.express.invoke_arn
}

# --- OPTIONS on {proxy+} (CORS preflight) ---

resource "aws_api_gateway_method" "express_proxy_options" {
  rest_api_id   = aws_api_gateway_rest_api.express_api.id
  resource_id   = aws_api_gateway_resource.express_proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "express_proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.express_api.id
  resource_id = aws_api_gateway_resource.express_proxy.id
  http_method = aws_api_gateway_method.express_proxy_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "express_proxy_options_200" {
  rest_api_id = aws_api_gateway_rest_api.express_api.id
  resource_id = aws_api_gateway_resource.express_proxy.id
  http_method = aws_api_gateway_method.express_proxy_options.http_method
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

resource "aws_api_gateway_integration_response" "express_proxy_options_200" {
  rest_api_id = aws_api_gateway_rest_api.express_api.id
  resource_id = aws_api_gateway_resource.express_proxy.id
  http_method = aws_api_gateway_method.express_proxy_options.http_method
  status_code = aws_api_gateway_method_response.express_proxy_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${local.s3_website_url}'"
  }

  depends_on = [aws_api_gateway_integration.express_proxy_options]
}

# --- Deployment & Stage ---

resource "aws_api_gateway_deployment" "express_api" {
  rest_api_id = aws_api_gateway_rest_api.express_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.express_root_any,
      aws_api_gateway_integration.express_root_any,
      aws_api_gateway_resource.express_proxy,
      aws_api_gateway_method.express_proxy_any,
      aws_api_gateway_integration.express_proxy_any,
      aws_api_gateway_method.express_proxy_options,
      aws_api_gateway_integration.express_proxy_options,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.express_root_any,
    aws_api_gateway_integration.express_proxy_any,
    aws_api_gateway_integration.express_proxy_options,
  ]
}

resource "aws_api_gateway_stage" "express_prod" {
  rest_api_id   = aws_api_gateway_rest_api.express_api.id
  deployment_id = aws_api_gateway_deployment.express_api.id
  stage_name    = "prod"

  tags = {
    team06 = "express_api"
  }
}

# --- Lambda Permission for Express API Gateway ---

resource "aws_lambda_permission" "express_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke-express"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.express.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.express_api.execution_arn}/*/*"
}

# --- Gateway Response for CORS on 4XX/5XX ---

resource "aws_api_gateway_gateway_response" "express_cors_4xx" {
  rest_api_id   = aws_api_gateway_rest_api.express_api.id
  response_type = "DEFAULT_4XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'${local.s3_website_url}'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
  }
}

resource "aws_api_gateway_gateway_response" "express_cors_5xx" {
  rest_api_id   = aws_api_gateway_rest_api.express_api.id
  response_type = "DEFAULT_5XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'${local.s3_website_url}'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
  }
}
