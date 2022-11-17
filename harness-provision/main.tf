# Create Projects
module "bootstrap_harness_projects" {
  source                    = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-project?ref=main"
  suffix                    = random_string.suffix.id
  harness_platform_projects = var.harness_platform_projects
}

# # Creates and Setup Harness connectors
# # TODO: Add GCP, Azure and CCM connectors
# module "bootstrap_harness_connectors" {
#   depends_on = [
#     module.bootstrap_harness_account,
#   ]
#   source                             = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-connectors?ref=main"
#   suffix                             = random_string.suffix.id
#   harness_platform_github_connectors = local.github_connectors
#   harness_platform_k8s_connectors    = local.k8s_connectors
#   harness_platform_docker_connectors = local.docker_connectors
#   harness_platform_aws_connectors    = local.aws_connectors
# }

# module "bootstrap_harness_pipelines" {
#   depends_on = [
#     module.bootstrap_harness_account,
#     module.bootstrap_harness_delegates
#   ]
#   source                     = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-pipeline?ref=main"
#   suffix                     = random_string.suffix.id
#   harness_platform_pipelines = local.pipelines
# }

output "test" {
  value = local.org_id
}
output "test2" {
  value = local.projects
}
