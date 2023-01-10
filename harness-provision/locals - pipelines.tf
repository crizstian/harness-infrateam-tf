# seed pipeline
locals {
  store_pipelines_in_git = try(var.github_details.enable, false)

  templated_common_vars = {
    delegate_ref      = local.delegate_ref
    k8s_connector_ref = local.k8s_connector_ref
    docker_ref        = local.docker_connector_ref
    git_connector_ref = local.github_connector_ref
    git_repo_ref      = local.onboarding_state.organizations[var.organization_prefix].git_repo_name
    service_ref       = try(module.bootstrap_harness_delegates.delegate_init.service_ref, "")
    environment_ref   = try(module.bootstrap_harness_delegates.delegate_init.environment_ref, "")
  }
}

# org pipelines
locals {
  pipelines = { for pipe, values in var.harness_platform_pipelines : pipe => {
    pipeline = merge(
      values.components.pipeline,
      {
        vars = try(values.components.pipeline.foreign_pipeline, false) ? merge(
          local.remote_state.pipelines[pipe].vars,
          { remote_id = local.remote_state.pipelines[pipe].pipeline_id }
          ) : merge(
          values.components.pipeline.vars,
          local.common_schema,
          local.templated_common_vars,
          {
            org_id            = module.bootstrap_harness_projects.project[values.project_ref].org_id
            project_id        = module.bootstrap_harness_projects.project[values.project_ref].identifier
            git_connector_ref = try(local.module_connectors.github_connectors[values.components.pipeline.vars.git_connector].identifier, local.github_connector_ref)
          },
          [for template_ref, details in try(values.components.pipeline.stages, {}) :
            {
              template_id      = try(local.module_templates[template_ref].identifier, try(local.templates_account_ref[template_ref].identifier, ""))
              template_version = try(details.version, "")
            } if try(details.template_stage, false)
          ]...
        )
      }
    )
    inputset = { for input, details in try(values.components.inputset, {}) : input => merge(
      details,
      {
        vars = merge(
          details.vars,
          local.templated_common_vars,
          {
            docker_connector_ref = try(local.module_connectors.docker_connectors[details.vars.docker_connector].identifier, local.docker_account_ref)
          }
      ) }
    ) if details.enable },
    trigger = { for t, details in try(values.components.trigger, {}) : t => details if details.enable }
    } if values.components.pipeline.enable
  }
}
