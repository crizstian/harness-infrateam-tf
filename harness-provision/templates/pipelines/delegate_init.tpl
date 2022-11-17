pipeline:
  name: ${name}
  identifier: ${name}_${suffix}
  projectIdentifier: ${project_id}
  orgIdentifier: ${org_id}
  tags: {}
  stages:
    - stage:
        name: Provision
        identifier: Provision_${suffix}
        description: ""
        type: Deployment
        spec:
          serviceConfig:
            serviceRef: ${service_ref}
            serviceDefinition:
              spec:
                variables: []
              type: Kubernetes
          infrastructure:
            environmentRef: ${environment_ref}
            infrastructureDefinition:
              type: KubernetesDirect
              spec:
                connectorRef: <+stage.variables.connector_ref>
                namespace: harness-delegate-ng
                releaseName: release-<+INFRA_KEY>
            allowSimultaneousDeployments: false
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Update Linux Dependencies
                  identifier: Update_Linux_Dependencies
                  spec:
                    shell: Bash
                    onDelegate: true
                    source:
                      type: Inline
                      spec:
                        script: |-
                          echo "update linux dependencies"

                          export DEBIAN_FRONTEND=noninteractive

                          apt-get update
                          apt-get install -y \
                              gnupg \
                              software-properties-common \
                              curl \
                              git
                    environmentVariables: []
                    outputVariables: []
                  timeout: 10m
              - stepGroup:
                  name: Terraform Ecosystem
                  identifier: Terraform_Ecosystem
                  steps:
                    - parallel:
                        - step:
                            type: ShellScript
                            name: Install Terraform Binary
                            identifier: Install_Terraform_Binary
                            spec:
                              shell: Bash
                              onDelegate: true
                              source:
                                type: Inline
                                spec:
                                  script: |-
                                    echo "install terraform"

                                    curl -sL https://releases.hashicorp.com/terraform/<+stage.variables.TF_VERSION>/terraform_<+stage.variables.TF_VERSION>_linux_amd64.zip -o terraform.zip

                                    # Install terraform
                                    unzip terraform.zip
                                    chmod +x terraform
                                    mv terraform /usr/bin/terraform
                              environmentVariables: []
                              outputVariables: []
                            timeout: 10m
                            when:
                              stageStatus: Success
                            failureStrategies: []
                        - step:
                            type: ShellScript
                            name: TFLint Utils
                            identifier: Terraform_Utils
                            spec:
                              shell: Bash
                              onDelegate: true
                              source:
                                type: Inline
                                spec:
                                  script: curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
                              environmentVariables: []
                              outputVariables: []
                            timeout: 10m
                        - step:
                            type: ShellScript
                            name: Infracost Utils
                            identifier: Infracost_Utils
                            spec:
                              shell: Bash
                              onDelegate: true
                              source:
                                type: Inline
                                spec:
                                  script: curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
                              environmentVariables: []
                              outputVariables: []
                            timeout: 10m
                  when:
                    stageStatus: Success
                    condition: <+stage.variables.enable_terraform> == "true"
                  failureStrategies: []
              - stepGroup:
                  name: GCP Ecosystem
                  identifier: GCP_Ecosystem
                  steps:
                    - step:
                        type: ShellScript
                        name: Install gcloud Binary
                        identifier: Install_gcloud_Binary
                        spec:
                          shell: Bash
                          onDelegate: true
                          source:
                            type: Inline
                            spec:
                              script: |-
                                curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

                                # Installing the package
                                mkdir -p /usr/local/gcloud \
                                  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
                                  && /usr/local/gcloud/google-cloud-sdk/install.sh

                                # Adding the package path to local
                                export PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin

                                echo $PATH > ~/.bashrc

                                gcloud components install gke-gcloud-auth-plugin --quiet
                                gcloud components install kubectl --quiet
                          environmentVariables: []
                          outputVariables: []
                        timeout: 10m
                        when:
                          stageStatus: Success
                        failureStrategies: []
                  when:
                    stageStatus: Success
                    condition: <+stage.variables.enable_gcloud> == "true"
                  failureStrategies: []
            rollbackSteps: []
        tags: {}
        failureStrategies:
          - onFailure:
              errors:
                - AllErrors
              action:
                type: Abort
        variables:
          - name: TF_VERSION
            type: String
            description: ""
            value: 1.2.8
          - name: connector_ref
            type: String
            description: ""
            value: <+input>
          - name: enable_terraform
            type: String
            description: ""
            value: <+input>
          - name: enable_gcloud
            type: String
            description: ""
            value: <+input>
