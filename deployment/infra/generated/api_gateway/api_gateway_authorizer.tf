resource "aws_api_gateway_authorizer" "tfer--edw1co" {
  authorizer_result_ttl_in_seconds = "300"
  identity_source                  = "method.request.header.Authorization"
  name                             = "ParkingAPIAuthorizer"
  provider_arns                    = ["arn:aws:cognito-idp:us-east-1:701030859948:userpool/us-east-1_7mjuUoQqQ"]
  rest_api_id                      = "6vasen33q4"
  type                             = "COGNITO_USER_POOLS"
}

resource "aws_api_gateway_authorizer" "tfer--ee88ok" {
  authorizer_result_ttl_in_seconds = "300"
  identity_source                  = "method.request.header.Authorization"
  name                             = "team06_Auth"
  provider_arns                    = ["arn:aws:cognito-idp:us-east-1:701030859948:userpool/us-east-1_Rali2TdjH"]
  rest_api_id                      = "54fu8y3s9a"
  type                             = "COGNITO_USER_POOLS"
}

resource "aws_api_gateway_authorizer" "tfer--iu04o5" {
  authorizer_result_ttl_in_seconds = "300"
  identity_source                  = "method.request.header.Authorization"
  name                             = "Express_Auth"
  provider_arns                    = ["arn:aws:cognito-idp:us-east-1:701030859948:userpool/us-east-1_Rali2TdjH"]
  rest_api_id                      = "dxs9ctiiac"
  type                             = "COGNITO_USER_POOLS"
}

resource "aws_api_gateway_authorizer" "tfer--nwhohe" {
  authorizer_credentials           = "arn:aws:iam::701030859948:role/LabRole"
  authorizer_result_ttl_in_seconds = "300"
  authorizer_uri                   = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team02-api-gateway-custom-authorizer/invocations"
  identity_source                  = "method.request.header.Authorization"
  name                             = "team02-poker-api-authorizer"
  rest_api_id                      = "7z4ixuncja"
  type                             = "TOKEN"
}

resource "aws_api_gateway_authorizer" "tfer--r8s6cr" {
  authorizer_result_ttl_in_seconds = "300"
  identity_source                  = "method.request.header.Authorization"
  name                             = "team02-web-api-authorizer"
  provider_arns                    = ["arn:aws:cognito-idp:us-east-1:701030859948:userpool/us-east-1_RiuuXaPXB"]
  rest_api_id                      = "7z4ixuncja"
  type                             = "COGNITO_USER_POOLS"
}
