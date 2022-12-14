# GITHUB CONNECTORS
harness_platform_github_connectors = {
  infrateam_account = {
    enable          = true
    description     = "Connector generated by terraform harness provider"
    connection_type = "Account"
    url             = "https://github.com/crizstian/"
    validation_repo = "harness-infrateam-tf"
    credentials = {
      http = {
        username     = "crizstian"
        token_ref_id = "account.crizstian_github_token"
      }
    }
    api_authentication = {
      token_ref_id = "account.crizstian_github_token"
    }
  }
}

# DOCKER CONNECTORS
harness_platform_docker_connectors = {}

# AWS CONNECTORS
harness_platform_aws_connectors = {
  infrateam_account = {
    enable      = true
    description = "Connector generated by terraform harness provider"
    manual = {
      access_key_ref = "account.cristian_aws_access_key"
      secret_key_ref = "account.cristian_aws_secret_key"
    }
  }
}

# GCP CONNECTORS
harness_platform_gcp_connectors = {
  infrateam_account = {
    enable      = true
    description = "Connector generated by terraform harness provider"
    manual = {
      secret_key_ref = "account.Cristian_GOOGLE_BACKEND_CREDENTIALS"
    }
  }
}
