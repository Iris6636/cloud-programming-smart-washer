resource "aws_api_gateway_integration_response" "tfer--42a6clquqe-002F-uq4a3r-002F-GET-002F-200" {
  http_method = "GET"
  resource_id = "uq4a3r"
  rest_api_id = "42a6clquqe"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--42a6clquqe-002F-uq4a3r-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "uq4a3r"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "42a6clquqe"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-0r6m1r-002F-ANY-002F-200" {
  http_method       = "ANY"
  resource_id       = "0r6m1r"
  rest_api_id       = "54fu8y3s9a"
  selection_pattern = ".*"
  status_code       = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-3kcp2h-002F-ANY-002F-200" {
  http_method       = "ANY"
  resource_id       = "3kcp2h"
  rest_api_id       = "54fu8y3s9a"
  selection_pattern = ".*"
  status_code       = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-5xcch2-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "5xcch2"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-5xcch2-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "5xcch2"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-6c4ve1-002F-ANY-002F-200" {
  http_method       = "ANY"
  resource_id       = "6c4ve1"
  rest_api_id       = "54fu8y3s9a"
  selection_pattern = ".*"
  status_code       = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-6to0ly-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "6to0ly"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-6to0ly-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "6to0ly"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-86eh8l-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "86eh8l"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-86eh8l-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "86eh8l"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-xju3ch-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "xju3ch"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--54fu8y3s9a-002F-xju3ch-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "xju3ch"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "54fu8y3s9a"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-3ir5sn-002F-GET-002F-200" {
  http_method = "GET"
  resource_id = "3ir5sn"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-3ir5sn-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "3ir5sn"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-h72zzg-002F-GET-002F-200" {
  http_method = "GET"
  resource_id = "h72zzg"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-h72zzg-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "h72zzg"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-li90vc-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "li90vc"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-li90vc-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "li90vc"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-souuc0-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "souuc0"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-souuc0-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "souuc0"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-trcrjo-002F-GET-002F-200" {
  http_method = "GET"
  resource_id = "trcrjo"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-trcrjo-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "trcrjo"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--6vasen33q4-002F-trcrjo-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "trcrjo"
  rest_api_id = "6vasen33q4"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-3dp4kg-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "3dp4kg"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-4p4zzj-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "4p4zzj"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"     = "'OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"      = "'https://dz71xa9wu0leo.cloudfront.net'"
    "method.response.header.Access-Control-Max-Age"           = "'3600'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-gmab69-002F-GET-002F-200" {
  http_method = "GET"
  resource_id = "gmab69"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://dz71xa9wu0leo.cloudfront.net'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-gmab69-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "gmab69"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,Cache-Control,pragma'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"      = "'https://dz71xa9wu0leo.cloudfront.net'"
    "method.response.header.Access-Control-Max-Age"           = "'3600'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-oy76ng-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "oy76ng"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"     = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"      = "'https://dz71xa9wu0leo.cloudfront.net'"
    "method.response.header.Access-Control-Max-Age"           = "'3600'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-oy76ng-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "oy76ng"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://dz71xa9wu0leo.cloudfront.net'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-skxs0h-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "skxs0h"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-tarii2-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "tarii2"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-tarii2-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "tarii2"
  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-tfd3mq-002F-GET-002F-200" {
  http_method = "GET"
  resource_id = "tfd3mq"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://dz71xa9wu0leo.cloudfront.net'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-tfd3mq-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "tfd3mq"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"      = "'https://dz71xa9wu0leo.cloudfront.net'"
    "method.response.header.Access-Control-Max-Age"           = "'3600'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-v2e0y9-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "v2e0y9"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--7z4ixuncja-002F-v2e0y9-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "v2e0y9"
  rest_api_id = "7z4ixuncja"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--dxs9ctiiac-002F-k4pkp4-002F-ANY-002F-200" {
  http_method       = "ANY"
  resource_id       = "k4pkp4"
  rest_api_id       = "dxs9ctiiac"
  selection_pattern = ".*"
  status_code       = "200"
}

resource "aws_api_gateway_integration_response" "tfer--dxs9ctiiac-002F-rd88xx-002F-ANY-002F-200" {
  http_method = "ANY"
  resource_id = "rd88xx"
  rest_api_id = "dxs9ctiiac"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--dxs9ctiiac-002F-rd88xx-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "rd88xx"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'http://team06website.s3-website-us-east-1.amazonaws.com'"
  }

  rest_api_id = "dxs9ctiiac"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--gt3fvvf2pg-002F-vwb0qn-002F-OPTIONS-002F-200" {
  http_method = "OPTIONS"
  resource_id = "vwb0qn"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  rest_api_id = "gt3fvvf2pg"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "tfer--gt3fvvf2pg-002F-vwb0qn-002F-POST-002F-200" {
  http_method = "POST"
  resource_id = "vwb0qn"
  rest_api_id = "gt3fvvf2pg"
  status_code = "200"
}
