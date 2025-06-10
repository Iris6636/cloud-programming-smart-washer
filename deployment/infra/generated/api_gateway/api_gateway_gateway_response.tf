resource "aws_api_gateway_gateway_response" "tfer--54fu8y3s9a-002F-DEFAULT_4XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_4XX"
  rest_api_id   = "54fu8y3s9a"
}

resource "aws_api_gateway_gateway_response" "tfer--54fu8y3s9a-002F-DEFAULT_5XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_5XX"
  rest_api_id   = "54fu8y3s9a"
}

resource "aws_api_gateway_gateway_response" "tfer--6vasen33q4-002F-DEFAULT_4XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_4XX"
  rest_api_id   = "6vasen33q4"
}

resource "aws_api_gateway_gateway_response" "tfer--6vasen33q4-002F-DEFAULT_5XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_5XX"
  rest_api_id   = "6vasen33q4"
}

resource "aws_api_gateway_gateway_response" "tfer--7z4ixuncja-002F-DEFAULT_4XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,Cache-Control,pragma'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "'https://dz71xa9wu0leo.cloudfront.net'"
    "gatewayresponse.header.Access-Control-Max-Age"           = "'3600'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_4XX"
  rest_api_id   = "7z4ixuncja"
}

resource "aws_api_gateway_gateway_response" "tfer--7z4ixuncja-002F-DEFAULT_5XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Credentials" = "'true'"
    "gatewayresponse.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,Cache-Control,pragma'"
    "gatewayresponse.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "gatewayresponse.header.Access-Control-Allow-Origin"      = "'https://dz71xa9wu0leo.cloudfront.net'"
    "gatewayresponse.header.Access-Control-Max-Age"           = "'3600'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_5XX"
  rest_api_id   = "7z4ixuncja"
}

resource "aws_api_gateway_gateway_response" "tfer--dxs9ctiiac-002F-DEFAULT_4XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_4XX"
  rest_api_id   = "dxs9ctiiac"
}

resource "aws_api_gateway_gateway_response" "tfer--dxs9ctiiac-002F-DEFAULT_5XX" {
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_type = "DEFAULT_5XX"
  rest_api_id   = "dxs9ctiiac"
}
