pipeline:
  name: ${name}
  identifier: ${name}_${suffix}
  projectIdentifier: ${project_id}
  orgIdentifier: ${org_id}
  tags: {}
  stages:
    - stage:
        name: Provisioning
        identifier: Provisioning
        description: ""
        type: Custom
        spec:
          execution:
            steps:
              - stepGroup:
                  name: Terraform Deployment
                  identifier: Terraform_Deployment
                  steps:
                    - step:
                        type: TerraformPlan
                        name: TF Plan
                        identifier: TF_Plan
                        spec:
                          configuration:
                            command: Apply
                            workspace: <+stage.variables.tf_workspace>
                            configFiles:
                              store:
                                type: Github
                                spec:
                                  gitFetchType: Branch
                                  connectorRef: ${git_connector_ref}
                                  repoName: "<+stage.variables.tf_repo_name>"
                                  branch: <+stage.variables.tf_branch>
                                  folderPath: <+stage.variables.tf_folder>
                              moduleSource:
                                useConnectorCredentials: true
                            secretManagerRef: account.harnessSecretManager
                            backendConfig:
                              type: Inline
                              spec:
                                content: |-
                                  bucket = "<+stage.variables.tf_backend_bucket>"
                                  key = "<+stage.variables.tf_backend_prefix>"
                                  region = "<+stage.variables.tf_backend_region>"
                            environmentVariables:
                              - name: AWS_ACCESS_KEY_ID
                                value: <+stage.variables.tf_access_key>
                                type: String
                              - name: AWS_SECRET_ACCESS_KEY
                                value: <+stage.variables.tf_secret_key>
                                type: String
                            varFiles:
                              - varFile:
                                  type: Remote
                                  identifier: vars
                                  spec:
                                    store:
                                      type: Github
                                      spec:
                                        gitFetchType: Branch
                                        repoName: "<+stage.variables.tf_repo_name>"
                                        branch: <+stage.variables.tf_branch>
                                        paths:
                                          - tfvars/<+stage.variables.tf_workspace>/account.tfvars
                                          - tfvars/<+stage.variables.tf_workspace>/k8s.tfvars
                                          - tfvars/<+stage.variables.tf_workspace>/vpc.tfvars
                                        connectorRef: ${git_connector_ref}
                          provisionerIdentifier: <+stage.variables.tf_workspace>
                        timeout: 1h
                    - step:
                        type: HarnessApproval
                        name: Approve
                        identifier: Approve
                        spec:
                          approvalMessage: Please review the following information and approve the pipeline progression
                          includePipelineExecutionHistory: true
                          approvers:
                            userGroups:
                              - ${approver_ref}
                            minimumCount: 1
                            disallowPipelineExecutor: false
                          approverInputs: []
                        timeout: 1d
                    - parallel:
                        - step:
                            type: TerraformApply
                            name: TF Apply
                            identifier: TF_Apply
                            spec:
                              configuration:
                                type: InheritFromPlan
                              provisionerIdentifier: <+stage.variables.tf_workspace>
                            timeout: 1h
                            when:
                              stageStatus: Success
                              condition: <+stage.variables.tf_action> == "apply"
                        - step:
                            type: TerraformDestroy
                            name: TF Destroy
                            identifier: TF_Destroy
                            spec:
                              provisionerIdentifier: <+stage.variables.tf_workspace>
                              configuration:
                                type: InheritFromPlan
                            timeout: 1h
                            when:
                              stageStatus: Success
                              condition: <+stage.variables.tf_action> == "destroy"
                  failureStrategies: []
                  delegateSelectors:
                    - ${delegate_ref}
                - step:
                    type: TerraformRollback
                    name: TF Rollback
                    identifier: TF_Rollback
                    spec:
                      provisionerIdentifier: <+stage.variables.tf_workspace>
                    timeout: 1h
                    when:
                      stageStatus: Failure
                    failureStrategies: []
            rollbackSteps: []
        tags: {}
        failureStrategies:
          - onFailure:
              errors:
                - AllErrors
              action:
                type: StageRollback
        variables:
          - name: tf_repo_name
            type: String
            description: ""
            value: <+input>
          - name: tf_branch
            type: String
            description: ""
            value: <+input>
          - name: tf_folder
            type: String
            description: ""
            value: <+input>
          - name: tf_workspace
            type: String
            description: ""
            value: <+input>
          - name: tf_backend_bucket
            type: String
            description: ""
            value: <+input>
          - name: tf_backend_prefix
            type: String
            description: ""
            value: <+input>
          - name: tf_backend_region
            type: String
            description: ""
            value: <+input>
          - name: tf_access_key
            type: Secret
            description: ""
            value: account.cristian_aws_access_key
          - name: tf_secret_key
            type: Secret
            description: ""
            value: account.cristian_aws_secret_key
          - name: tf_action
            type: String
            description: ""
            value: <+input>
