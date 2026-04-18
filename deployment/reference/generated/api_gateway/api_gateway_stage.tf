resource "aws_api_gateway_stage" "tfer--42a6clquqe-002F-prod" {
  cache_cluster_enabled = "false"
  deployment_id         = "0h9jsm"
  rest_api_id           = "42a6clquqe"
  stage_name            = "prod"
  xray_tracing_enabled  = "false"
}

resource "aws_api_gateway_stage" "tfer--54fu8y3s9a-002F-prod" {
  cache_cluster_enabled = "false"
  deployment_id         = "efbm7i"
  rest_api_id           = "54fu8y3s9a"
  stage_name            = "prod"

  tags = {
    team06 = "iot_api"
  }

  tags_all = {
    team06 = "iot_api"
  }

  xray_tracing_enabled = "false"
}

resource "aws_api_gateway_stage" "tfer--6vasen33q4-002F-v1" {
  cache_cluster_enabled = "false"
  deployment_id         = "tvyg26"
  rest_api_id           = "6vasen33q4"
  stage_name            = "v1"
  xray_tracing_enabled  = "false"
}

resource "aws_api_gateway_stage" "tfer--7z4ixuncja-002F-dev" {
  cache_cluster_enabled = "false"
  deployment_id         = "k60ot2"
  rest_api_id           = "7z4ixuncja"
  stage_name            = "dev"
  xray_tracing_enabled  = "false"
}

resource "aws_api_gateway_stage" "tfer--dxs9ctiiac-002F-prod" {
  cache_cluster_enabled = "false"
  deployment_id         = "e8f9t6"
  rest_api_id           = "dxs9ctiiac"
  stage_name            = "prod"

  tags = {
    team06 = "express_api"
  }

  tags_all = {
    team06 = "express_api"
  }

  xray_tracing_enabled = "false"
}

resource "aws_api_gateway_stage" "tfer--gt3fvvf2pg-002F-TEAM18" {
  cache_cluster_enabled = "false"
  deployment_id         = "8gj3e5"
  rest_api_id           = "gt3fvvf2pg"
  stage_name            = "TEAM18"
  xray_tracing_enabled  = "false"
}
