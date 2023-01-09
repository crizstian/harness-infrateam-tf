# Create Projects
module "bootstrap_harness_projects" {
  source                    = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-project?ref=main"
  suffix                    = random_string.suffix.id
  tags                      = local.common_tags.tags
  org_id                    = local.common_schema.org_id
  harness_platform_projects = var.harness_platform_projects
}

# Creates and uploads delegates manifests to Harness FileStore: => Account/Org/File
# Configures delegates at Account Level
# TODO: Auto Install delegates
module "bootstrap_harness_delegates" {
  source = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-delegate?ref=main"

  suffix                = random_string.suffix.id
  tags                  = local.common_tags.tags
  delegate_init_service = local.delegate_init_service

  harness_platform_api_key   = var.harness_platform_api_key
  harness_account_id         = var.harness_platform_account_id
  harness_platform_delegates = var.harness_platform_delegates
}

# Creates and Setup Harness connectors
# TODO: Add GCP, Azure and CCM connectors
module "bootstrap_harness_connectors" {
  depends_on = [
    module.bootstrap_harness_projects
  ]
  source = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-connector?ref=main"

  suffix             = random_string.suffix.id
  tags               = local.common_tags.tags
  delegate_selectors = local.delegate_selectors
  org_id             = local.common_schema.org_id

  harness_platform_github_connectors = local.github_connectors
  harness_platform_docker_connectors = var.harness_platform_docker_connectors
  harness_platform_aws_connectors    = var.harness_platform_aws_connectors
  harness_platform_gcp_connectors    = var.harness_platform_gcp_connectors
}

# Creates Policies
module "bootstrap_harness_policies" {
  depends_on = [
    module.bootstrap_harness_projects
  ]
  source = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-policy?ref=main"

  suffix                    = random_string.suffix.id
  tags                      = local.common_tags.tags
  org_id                    = local.common_schema.org_id
  harness_platform_policies = local.policies
}

# Creates Pipeline Templates
module "bootstrap_harness_templates" {
  depends_on = [
    module.bootstrap_harness_projects,
    module.bootstrap_harness_delegates
  ]
  source = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-template?ref=main"

  suffix                     = random_string.suffix.id
  tags                       = local.common_tags.tags
  org_id                     = local.common_schema.org_id
  harness_platform_templates = local.templates
}

# # Creates Pipelines
module "bootstrap_harness_pipelines" {
  depends_on = [
    module.bootstrap_harness_projects,
    module.bootstrap_harness_connectors,
    module.bootstrap_harness_templates
  ]
  source = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-pipeline?ref=main"

  suffix                     = random_string.suffix.id
  tags                       = local.common_tags.tags
  harness_platform_pipelines = local.pipelines
  store_pipelines_in_git     = local.store_pipelines_in_git

  github_details      = var.github_details
  organization_prefix = var.organization_prefix
}
