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
            - name: GCP_PROJECT_ID
              type: String
              value: ${GCP_PROJECT_ID}
            - name: GCP_REGION
              type: String
              value: ${GCP_REGION}
            - name: GCP_ZONE
              type: String
              value: ${GCP_ZONE}
