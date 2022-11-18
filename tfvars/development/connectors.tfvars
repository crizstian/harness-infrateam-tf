# GITHUB CONNECTORS
harness_platform_github_connectors = {
  infrateam = {
    id              = "org.infrateam_org_github_connector_nyKx"
    enable          = false
    description     = "Connector generated by terraform harness provider"
    connection_type = "Account"
    url             = "https://github.com/crizstian/"
    validation_repo = "harness-infrateam-tf "
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
harness_platform_docker_connectors = {
  infrateam = {
    enable             = true
    description        = "Connector generated by terraform harness provider"
    type               = "DockerHub"
    url                = "https://index.docker.io/v2/"
    delegate_selectors = ["cristian-delegate-tf"]
    credentials = {
      username        = "crizstian"
      password_ref_id = "account.crizstian_docker_token"
    }
  }
}

# AWS CONNECTORS
harness_platform_aws_connectors = {
  infrateam_account = {
    enable      = true
    description = "Connector generated by terraform harness provider"
    manual = {
      access_key_ref     = "account.cristian_aws_access_key"
      secret_key_ref     = "account.cristian_aws_secret_key"
      delegate_selectors = ["cristian-delegate-tf"]
    }
  }
}
