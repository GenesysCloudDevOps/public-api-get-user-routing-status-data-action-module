resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "A user ID-based request.",
        "properties" = {
            "USER_ID" = {
                "description" = "The user ID.",
                "type" = "string"
            }
        },
        "required" = [
            "USER_ID"
        ],
        "title" = "UserIdRequest",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "Returns a user\u2019s routing status.",
        "properties" = {
            "status" = {
                "description" = "The user\u2019s routing status, which indicates whether the user is able to receive ACD interactions.",
                "title" = "Status",
                "type" = "string"
            }
        },
        "title" = "Get User Routing Status Response",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/users/$${input.USER_ID}/routingstatus"
        headers = {
            UserAgent = "PureCloudIntegrations/1.0"
            Content-Type = "application/x-www-form-urlencoded"
        }
    }

    config_response {
        success_template = "{\n   \"status\": $${status}\n}"
        translation_map = { 
            status = "$.status"
        }      
    }
}