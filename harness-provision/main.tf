# Creates and Setup Harness connectors
module "bootstrap_harness_connectors" {
  source                             = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-connectors?ref=main"
  suffix                             = random_string.suffix.id
  harness_platform_github_connectors = local.github_connectors
  harness_platform_docker_connectors = local.docker_connectors
  harness_platform_aws_connectors    = local.aws_connectors

  # requires to provision first the infra
  # harness_platform_k8s_connectors    = local.k8s_connectors
}

# Create Projects
module "bootstrap_harness_projects" {
  source                    = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-project?ref=main"
  suffix                    = random_string.suffix.id
  harness_platform_projects = local.projects
}

# Creates Pipelines
module "bootstrap_harness_pipelines" {
  depends_on = [
    module.bootstrap_harness_projects,
    module.bootstrap_harness_connectors,
  ]
  source                     = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-pipeline?ref=main"
  suffix                     = random_string.suffix.id
  harness_platform_pipelines = local.pipelines
}

# Outputs
output "projects" {
  value = module.bootstrap_harness_projects.project
}
output "connectors" {
  value = module.bootstrap_harness_connectors.connectors
}
