inputSet:
  identifier: ${identifier}
  name: ${name}
  tags: {}
  projectIdentifier: ${project_id}
  orgIdentifier: ${org_id}
  pipeline:
    identifier: ${pipeline_id}
    stages:
      - stage:
          identifier: Build_Image
          type: CI
          variables:
            - name: git_repo
              type: String
              value: ${git_repo}
            - name: k8s_connector_ref
              type: String
              value: ${k8s_connector_ref}
            - name: docker_connector_ref
              type: String
              value: ${docker_connector_ref}
            - name: AWS_REGION
              type: String
              value: ${AWS_REGION}
