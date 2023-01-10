pipeline:
  name: ${name}
  identifier: ${name}_${suffix}
  projectIdentifier: ${project_id}
  orgIdentifier: ${org_id}
  tags: {}
  properties:
    ci:
      codebase:
        connectorRef: ${git_connector_ref}
        repoName: <+stage.variables.git_repo>
        build: <+input>
  stages:
    - stage:
        name: Build Image
        identifier: Build_Image
        description: ""
        type: CI
        spec:
          cloneCodebase: true
          infrastructure:
            type: KubernetesDirect
            spec:
              connectorRef: <+stage.variables.k8s_connector_ref>
              namespace: harness-delegate-ng
              automountServiceAccountToken: true
              nodeSelector: {}
              os: Linux
          execution:
            steps:
              - step:
                  type: Run
                  name: Packer
                  identifier: Packer
                  spec:
                    connectorRef: <+stage.variables.docker_connector_ref>
                    image: hashicorp/packer
                    shell: Bash
                    command: |-
                      cat << EOF > sa.json
                      <+stage.variables.GOOGLE_APPLICATION_CREDENTIALS>
                      EOF

                      export GOOGLE_APPLICATION_CREDENTIALS=../sa.json

                      cd gcp

                      cat << EOF > variables.hcl
                      # Packer variables (all are required)
                      project                   = "<+stage.variables.GCP_PROJECT_ID>"
                      region                    = "<+stage.variables.GCP_REGION>"
                      zone                      = "<+stage.variables.GCP_ZONE>"
                      EOF

                      cat variables.hcl

                      packer init image.pkr.hcl

                      packer build -var-file=variables.hcl image.pkr.hcl 
        variables:
          - name: git_repo
            type: String
            description: ""
            value: <+input>
          - name: k8s_connector_ref
            type: String
            description: ""
            value: <+input>
          - name: docker_connector_ref
            type: String
            description: ""
            value: <+input>
          - name: GCP_PROJECT_ID
            type: String
            description: ""
            value: <+input>
          - name: GCP_REGION
            type: String
            description: ""
            value: <+input>
          - name: GCP_ZONE
            type: String
            description: ""
            value: <+input>
          - name: GOOGLE_APPLICATION_CREDENTIALS
            type: Secret
            description: ""
            value: account.Cristian_GOOGLE_BACKEND_CREDENTIALS
