resource "aws_api_gateway_integration" "tfer--42a6clquqe-002F-uq4a3r-002F-GET" {
  cache_namespace         = "uq4a3r"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "GET"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "uq4a3r"
  rest_api_id             = "42a6clquqe"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team11-fetch-board-data/invocations"
}

resource "aws_api_gateway_integration" "tfer--42a6clquqe-002F-uq4a3r-002F-OPTIONS" {
  cache_namespace      = "uq4a3r"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "uq4a3r"
  rest_api_id          = "42a6clquqe"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-0r6m1r-002F-ANY" {
  cache_namespace         = "0r6m1r"
  connection_type         = "INTERNET"
  http_method             = "ANY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "0r6m1r"
  rest_api_id             = "54fu8y3s9a"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06_HandleUseRequest_WithReservation/invocations"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-3kcp2h-002F-ANY" {
  cache_namespace         = "3kcp2h"
  connection_type         = "INTERNET"
  http_method             = "ANY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "3kcp2h"
  rest_api_id             = "54fu8y3s9a"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06_HandleReserveRequest/invocations"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-5xcch2-002F-OPTIONS" {
  cache_namespace      = "5xcch2"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "5xcch2"
  rest_api_id          = "54fu8y3s9a"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-5xcch2-002F-POST" {
  cache_namespace         = "5xcch2"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "5xcch2"
  rest_api_id             = "54fu8y3s9a"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06_HandleUseRequest_NoReservation/invocations"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-6c4ve1-002F-ANY" {
  cache_namespace         = "6c4ve1"
  connection_type         = "INTERNET"
  http_method             = "ANY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "6c4ve1"
  rest_api_id             = "54fu8y3s9a"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06_HandleEndRequest_UnlockWasher/invocations"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-6to0ly-002F-OPTIONS" {
  cache_namespace      = "6to0ly"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "6to0ly"
  rest_api_id          = "54fu8y3s9a"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-6to0ly-002F-POST" {
  cache_namespace         = "6to0ly"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "6to0ly"
  rest_api_id             = "54fu8y3s9a"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06_HandleEndRequest_UnlockWasher/invocations"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-86eh8l-002F-OPTIONS" {
  cache_namespace      = "86eh8l"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "86eh8l"
  rest_api_id          = "54fu8y3s9a"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-86eh8l-002F-POST" {
  cache_namespace         = "86eh8l"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "86eh8l"
  rest_api_id             = "54fu8y3s9a"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06_HandleUseRequest_WithReservation/invocations"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-xju3ch-002F-OPTIONS" {
  cache_namespace      = "xju3ch"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "xju3ch"
  rest_api_id          = "54fu8y3s9a"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--54fu8y3s9a-002F-xju3ch-002F-POST" {
  cache_namespace         = "xju3ch"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "xju3ch"
  rest_api_id             = "54fu8y3s9a"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06_HandleReserveRequest/invocations"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-3ir5sn-002F-GET" {
  cache_namespace         = "3ir5sn"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "GET"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "3ir5sn"
  rest_api_id             = "6vasen33q4"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:Team4_getParkingSlots/invocations"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-3ir5sn-002F-OPTIONS" {
  cache_namespace      = "3ir5sn"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "3ir5sn"
  rest_api_id          = "6vasen33q4"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-h72zzg-002F-GET" {
  cache_namespace         = "h72zzg"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "GET"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "h72zzg"
  rest_api_id             = "6vasen33q4"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:Team4_getParkingSlots/invocations"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-h72zzg-002F-OPTIONS" {
  cache_namespace      = "h72zzg"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "h72zzg"
  rest_api_id          = "6vasen33q4"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-li90vc-002F-OPTIONS" {
  cache_namespace      = "li90vc"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "li90vc"
  rest_api_id          = "6vasen33q4"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-li90vc-002F-POST" {
  cache_namespace         = "li90vc"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "li90vc"
  rest_api_id             = "6vasen33q4"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:Team4_handleReservation/invocations"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-souuc0-002F-OPTIONS" {
  cache_namespace      = "souuc0"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "souuc0"
  rest_api_id          = "6vasen33q4"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-souuc0-002F-POST" {
  cache_namespace         = "souuc0"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "souuc0"
  rest_api_id             = "6vasen33q4"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:Team4_cancelResevation/invocations"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-trcrjo-002F-GET" {
  cache_namespace         = "trcrjo"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "GET"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "trcrjo"
  rest_api_id             = "6vasen33q4"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:Team4_getUserProfile/invocations"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-trcrjo-002F-OPTIONS" {
  cache_namespace      = "trcrjo"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "trcrjo"
  rest_api_id          = "6vasen33q4"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--6vasen33q4-002F-trcrjo-002F-POST" {
  cache_namespace         = "trcrjo"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "trcrjo"
  rest_api_id             = "6vasen33q4"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:Team4_modifyUserProfile/invocations"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-3dp4kg-002F-OPTIONS" {
  cache_namespace      = "3dp4kg"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "3dp4kg"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-4p4zzj-002F-OPTIONS" {
  cache_namespace      = "4p4zzj"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "4p4zzj"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-gmab69-002F-GET" {
  cache_namespace         = "gmab69"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "GET"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "gmab69"
  rest_api_id             = "7z4ixuncja"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team02-query-dynamodb/invocations"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-gmab69-002F-OPTIONS" {
  cache_namespace      = "gmab69"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "gmab69"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-oy76ng-002F-OPTIONS" {
  cache_namespace      = "oy76ng"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "oy76ng"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-oy76ng-002F-POST" {
  cache_namespace         = "oy76ng"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "oy76ng"
  rest_api_id             = "7z4ixuncja"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team02-email-notification/invocations"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-skxs0h-002F-OPTIONS" {
  cache_namespace      = "skxs0h"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "skxs0h"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-tarii2-002F-OPTIONS" {
  cache_namespace      = "tarii2"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "tarii2"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-tarii2-002F-POST" {
  cache_key_parameters    = ["method.request.header.Authorization"]
  cache_namespace         = "tarii2"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "tarii2"
  rest_api_id             = "7z4ixuncja"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team02-upload-image/invocations"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-tfd3mq-002F-GET" {
  cache_namespace         = "tfd3mq"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "GET"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "tfd3mq"
  rest_api_id             = "7z4ixuncja"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team02-s3-presigned-url/invocations"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-tfd3mq-002F-OPTIONS" {
  cache_namespace      = "tfd3mq"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "tfd3mq"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-v2e0y9-002F-OPTIONS" {
  cache_namespace      = "v2e0y9"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "v2e0y9"
  rest_api_id          = "7z4ixuncja"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--7z4ixuncja-002F-v2e0y9-002F-POST" {
  cache_key_parameters    = ["method.request.header.Authorization"]
  cache_namespace         = "v2e0y9"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "v2e0y9"
  rest_api_id             = "7z4ixuncja"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team02-upload-image/invocations"
}

resource "aws_api_gateway_integration" "tfer--dxs9ctiiac-002F-k4pkp4-002F-ANY" {
  cache_namespace         = "k4pkp4"
  connection_type         = "INTERNET"
  http_method             = "ANY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "k4pkp4"
  rest_api_id             = "dxs9ctiiac"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06-express/invocations"
}

resource "aws_api_gateway_integration" "tfer--dxs9ctiiac-002F-rd88xx-002F-ANY" {
  cache_key_parameters    = ["method.request.path.proxy"]
  cache_namespace         = "rd88xx"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "ANY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "rd88xx"
  rest_api_id             = "dxs9ctiiac"
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:701030859948:function:team06-express/invocations"
}

resource "aws_api_gateway_integration" "tfer--dxs9ctiiac-002F-rd88xx-002F-OPTIONS" {
  cache_namespace      = "rd88xx"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "rd88xx"
  rest_api_id          = "dxs9ctiiac"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--gt3fvvf2pg-002F-vwb0qn-002F-OPTIONS" {
  cache_namespace      = "vwb0qn"
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  resource_id          = "vwb0qn"
  rest_api_id          = "gt3fvvf2pg"
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "tfer--gt3fvvf2pg-002F-vwb0qn-002F-POST" {
  cache_namespace         = "vwb0qn"
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = "vwb0qn"
  rest_api_id             = "gt3fvvf2pg"
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-southeast-2:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-southeast-2:701030859948:function:TEAM18_UPLOAD_IMAGE/invocations"
}
