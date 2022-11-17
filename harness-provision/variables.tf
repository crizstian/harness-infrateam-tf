variable "harness_platform_account_id" {}
variable "harness_platform_api_key" {
  sensitive = true
}
variable "harness_platform_projects" {}
variable "harness_platform_pipelines" {}
variable "harness_platform_delegates" {}
variable "harness_platform_github_connectors" {}
variable "organization_prefix" {}
variable "remote_state" {}

locals {
  org_id   = data.terraform_remote_state.harness.outputs.organizations[var.organization_prefix].org_id
  projects = { for key, value in var.harness_platform_projects : key => merge(value, { org_id = local.org_id }) }
}
