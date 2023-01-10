inputSet:
  identifier: ${identifier}
  name: ${name}
  tags: {}
  projectIdentifier: ${project_id}
  orgIdentifier: ${org_id}
  pipeline:
    identifier: ${pipeline_id}
    properties:
      ci:
        codebase:
          build:
            type: branch
            spec:
              branch: <+trigger.sourceBranch>
    stages:
      - stage:
          identifier: Terraform_STO
          template:
            templateInputs:
              type: CI
              variables:
                - name: k8s_connector_ref
                  type: String
                  value: ${k8s_connector_ref}
                - name: docker_connector_ref
                  type: String
                  value: ${docker_connector_ref}