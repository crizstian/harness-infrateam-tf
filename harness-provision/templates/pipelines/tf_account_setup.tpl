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
                  name: Terraform Run
                  identifier: Terraform_Run
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
                                  branch: <+stage.variables.tf_branch>
                                  folderPath: <+stage.variables.tf_folder>
                            secretManagerRef: harnessSecretManager
                            backendConfig:
                              type: Inline
                              spec:
                                content: |-
                                  bucket = "<+stage.variables.tf_backend_bucket>"
                                  prefix = "<+stage.variables.tf_backend_prefix>"
                            environmentVariables:
                              - name: HARNESS_ACCOUNT_ID
                                value: <+stage.variables.harness_account_id>
                                type: String
                              - name: HARNESS_PLATFORM_API_KEY
                                value: <+stage.variables.harness_api_key>
                                type: String
                              - name: HARNESS_ENDPOINT
                                value: <+stage.variables.harness_endpoint>
                                type: String
                              - name: GOOGLE_BACKEND_CREDENTIALS
                                value: <+stage.variables.tf_gcp_keys>
                                type: String
                            varFiles:
                              - varFile:
                                  type: Remote
                                  identifier: tf_remote_seed_lab
                                  spec:
                                    store:
                                      type: Github
                                      spec:
                                        gitFetchType: Branch
                                        repoName: ""
                                        branch: <+stage.variables.tf_branch>
                                        paths:
                                          - tfvars/<+stage.variables.tf_branch>/account.tfvars
                                          - tfvars/<+stage.variables.tf_branch>/connectors.tfvars
                                          - tfvars/<+stage.variables.tf_branch>/delegates.tfvars
                                          - tfvars/<+stage.variables.tf_branch>/pipelines.tfvars
                                        connectorRef: ${git_connector_ref}
                              - varFile:
                                  identifier: vars
                                  spec:
                                    content: harness_platform_api_key = "<+stage.variables.harness_api_key>"
                                  type: Inline
                          provisionerIdentifier: <+stage.variables.tf_workspace>
                        timeout: 10m
                        failureStrategies: []
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
                            timeout: 10m
                            when:
                              stageStatus: Success
                              condition: <+stage.variables.tf_action> == "apply"
                            failureStrategies: []
                        - step:
                            type: TerraformDestroy
                            name: TF Destroy
                            identifier: TF_Destroy
                            spec:
                              configuration:
                                type: InheritFromPlan
                              provisionerIdentifier: <+stage.variables.tf_workspace>
                            timeout: 10m
                            when:
                              stageStatus: Success
                              condition: <+stage.variables.tf_action> == "destroy"
                            failureStrategies: []
                  failureStrategies: []
                  delegateSelectors:
                    - ${delegate_ref}
            rollbackSteps: []
          serviceDependencies: []
        tags: {}
        variables:
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
          - name: tf_gcp_keys
            type: Secret
            description: ""
            value: account.Cristian_GOOGLE_BACKEND_CREDENTIALS
          - name: tf_action
            type: String
            description: ""
            value: <+input>
          - name: harness_api_key
            type: Secret
            description: ""
            value: account.cristian_harness_platform_api_key
          - name: harness_account_id
            type: String
            description: ""
            value: Io9SR1H7TtGBq9LVyJVB2w
          - name: harness_endpoint
            type: String
            description: ""
            value: https://app.harness.io/gateway
