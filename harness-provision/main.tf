# Create Projects
module "bootstrap_harness_projects" {
  source                    = "git::https://github.com/crizstian/harness-terraform-modules.git//harness-project?ref=main"
  suffix                    = random_string.suffix.id
  harness_platform_projects = local.projects
}


# Outputs
output "projects" {
  value = module.bootstrap_harness_projects.project
}
