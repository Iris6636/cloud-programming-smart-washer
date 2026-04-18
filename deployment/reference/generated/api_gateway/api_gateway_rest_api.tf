resource "aws_api_gateway_rest_api" "tfer--42a6clquqe_Team11-BoardAPI" {
  api_key_source               = "HEADER"
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    ip_address_type = "ipv4"
    types           = ["REGIONAL"]
  }

  name = "Team11-BoardAPI"
}

resource "aws_api_gateway_rest_api" "tfer--54fu8y3s9a_team06-iot-api" {
  api_key_source               = "HEADER"
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    ip_address_type = "ipv4"
    types           = ["REGIONAL"]
  }

  name = "team06-iot-api"
}

resource "aws_api_gateway_rest_api" "tfer--6vasen33q4_Team4_ParkingAPI" {
  api_key_source               = "HEADER"
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    ip_address_type = "ipv4"
    types           = ["REGIONAL"]
  }

  name = "Team4_ParkingAPI"
}

resource "aws_api_gateway_rest_api" "tfer--7z4ixuncja_team02-poker-api" {
  api_key_source               = "HEADER"
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    ip_address_type = "ipv4"
    types           = ["REGIONAL"]
  }

  name = "team02-poker-api"
}

resource "aws_api_gateway_rest_api" "tfer--dxs9ctiiac_team06-express" {
  api_key_source               = "HEADER"
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    ip_address_type = "ipv4"
    types           = ["REGIONAL"]
  }

  name = "team06-express"
}

resource "aws_api_gateway_rest_api" "tfer--gt3fvvf2pg_TEAM18_UPLOAD_IMAGE" {
  api_key_source               = "HEADER"
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    ip_address_type = "ipv4"
    types           = ["REGIONAL"]
  }

  name = "TEAM18_UPLOAD_IMAGE"
}
