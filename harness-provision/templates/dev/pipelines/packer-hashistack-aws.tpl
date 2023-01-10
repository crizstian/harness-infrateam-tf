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

                      export AWS_SECRET_ACCESS_KEY="<+stage.variables.AWS_SECRET_ACCESS_KEY>"
                      export AWS_ACCESS_KEY_ID="<+stage.variables.AWS_ACCESS_KEY_ID>"
                      export AWS_REGION="<+stage.variables.AWS_REGION>"

                      cd aws

                      cat << EOF > variables.hcl
                      # Packer variables (all are required)
                      region = "<+stage.variables.AWS_REGION>"
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
          - name: AWS_REGION
            type: String
            description: ""
            value: <+input>
          - name: AWS_ACCESS_KEY_ID
            type: Secret
            description: ""
            value: account.cristian_aws_access_key
          - name: AWS_SECRET_ACCESS_KEY
            type: Secret
            description: ""
            value: account.cristian_aws_secret_key
