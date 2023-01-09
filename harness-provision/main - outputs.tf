# Outputs
output "harness" {
  value = merge(
    length(keys(module.bootstrap_harness_projects.project)) > 0 ? { projects = module.bootstrap_harness_projects.project } : {},
    length(keys(module.bootstrap_harness_delegates.manifests)) > 0 ? { delegates = module.bootstrap_harness_delegates.manifests } : {},
    length(keys(module.bootstrap_harness_connectors.connectors)) > 0 ? { connectors = module.bootstrap_harness_connectors.connectors } : {},
    length(keys(module.bootstrap_harness_pipelines.pipelines)) > 0 ? { pipelines = module.bootstrap_harness_pipelines.pipelines } : {},
    length(keys(module.bootstrap_harness_templates.templates)) > 0 ? { templates = module.bootstrap_harness_templates.templates } : {},
    length(keys(module.bootstrap_harness_policies.policies)) > 0 ? { policies = module.bootstrap_harness_policies.policies } : {},
  )
}
