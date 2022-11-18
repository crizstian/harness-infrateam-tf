# harness variables
variable "harness_platform_api_key" {
  type      = string
  sensitive = true
}
variable "harness_platform_account_id" {
  type = string
}
variable "harness_platform_projects" {
  type = map(any)
}
variable "harness_platform_delegates" {
  type    = map(any)
  default = {}
}
variable "harness_platform_github_connectors" {
  type    = map(any)
  default = {}
}
variable "harness_platform_docker_connectors" {
  type    = map(any)
  default = {}
}
variable "harness_platform_aws_connectors" {
  type    = map(any)
  default = {}
}
variable "harness_platform_pipelines" {
  type    = map(any)
  default = {}
}
variable "harness_platform_inputsets" {
  type    = map(any)
  default = {}
}
# other variables
variable "organization_prefix" {
  type    = string
  default = ""
}
variable "remote_state" {
  # type    = map(any)
  default = {}
}

# common vars
locals {
  common_tags = { tags = ["owner: ${var.organization_prefix}"] }
  common_schema = {
    org_id = data.terraform_remote_state.harness.outputs.organizations[var.organization_prefix].org_id
    suffix = random_string.suffix.id
  }
  git_suffix = "_github_connector"
}

# projects vars
locals {
  projects = { for key, value in var.harness_platform_projects : key => merge(value, local.common_schema) }
}

# github connectors
locals {
  github_connectors = { for name, details in var.harness_platform_github_connectors : name => merge(
    details,
    local.common_tags,
    local.common_schema,
    {
      validation_repo = details.connection_type == "Repo" ? "" : details.validation_repo
      project_id      = try(details.project_id, "")
      credentials = {
        http = {
          username     = details.credentials.http.username
          token_ref_id = try(details.credentials.http.token_ref_id, "")
        }
      }
      api_authentication = {
        token_ref = try(details.credentials.http.token_ref_id, "")
      }
  }) }
}

# connectors
locals {
  docker_connectors = { for name, details in var.harness_platform_docker_connectors : name => merge(
    details,
    local.common_tags,
    local.common_schema
    )
    if details.enable
  }

  aws_connectors = { for name, details in var.harness_platform_aws_connectors : name => merge(
    details,
    local.common_tags,
    local.common_schema
    )
    if details.enable
  }
}

# pipelines
locals {
  pipelines = { for pipe, values in var.harness_platform_pipelines : pipe => {
    pipeline = merge(
      { for key, value in values : key => value if key != "custom_template" },
      values.custom_template.pipeline,
      {
        vars = merge(
          values.custom_template.pipeline.vars,
          local.common_schema,
          {
            project_id        = module.bootstrap_harness_projects.project[values.custom_template.pipeline.vars.project].identifier
            git_connector_ref = module.bootstrap_harness_connectors.connectors.github_connectors["${values.custom_template.pipeline.vars.git_connector}${local.git_suffix}"].identifier

            #service_ref       = module.bootstrap_harness_delegates.delegate_init.service_ref
            #environment_ref   = module.bootstrap_harness_delegates.delegate_init.environment_ref
          }
        )
      }
    )
    inputset = { for input, details in try(values.custom_template.inputset, {}) : input => merge(details) if details.enable }
    } if pipe != "harness_seed_setup"
  }
}
