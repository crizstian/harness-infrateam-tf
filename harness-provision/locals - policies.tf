# OPA policies 
locals {
  policies = { for key, values in var.harness_opa_policies : key => values if values.enable }

  #  policy_sets = { for key, values in var.harness_opa_policy_sets : key =>
  #    {
  #      request_type = "POST"
  #      content_type = "json"
  #      endpoint     = set.level == "account" ? "${var.harness_policy_api_endpoint}?${local.account_args}" : "${var.harness_policy_api_endpoint}?${local.organization_args}"
  #      content = jsonencode(
  #        {
  #          "identifier" : "test",
  #          "name" : "test",
  #          "description" : "test",
  #          "action" : "onsave",
  #          "type" : "pipeline",
  #          "enabled" : true,
  #          "account_id" : "Io9SR1H7TtGBq9LVyJVB2w",
  #          "org_id" : "cristian_lab_devsecops_org_Anuu",
  #          "project_id" : "seed_project_cristian_lab_devsecops_org_Anuu",
  #          "policies" : [
  #            {
  #              "identifier" : "account.approval_required_test_template_IqdH",
  #              "severity" : "error"
  #            }
  #          ]
  #        }
  #      )
  #    }
  #  if values.enable }
}
