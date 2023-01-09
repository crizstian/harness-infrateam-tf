# common vars
locals {
  onboarding_state = try(data.terraform_remote_state.onboarding.outputs.harness, {})
  remote_state     = try(data.terraform_remote_state.remote.outputs.harness, {})

  account_args            = "accountIdentifier=${var.harness_platform_account_id}"
  organization_args       = "${local.account_args}&orgIdentifier=${local.common_schema.org_id}"
  organization_short_name = local.onboarding_state.organizations[var.organization_prefix].short_name
  common_tags = {
    tags = [
      "owner: ${var.organization_prefix}",
      "tf_workspace: ${terraform.workspace}"
    ]
  }
  common_schema = {
    org_id = local.onboarding_state.organizations[var.organization_prefix].org_id
    suffix = random_string.suffix.id
  }
}
