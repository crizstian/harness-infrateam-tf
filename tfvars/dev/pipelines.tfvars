harness_platform_pipelines = {
  packer_hashistack_gcp = {
    project_ref = "hashicorp_stack_gcp"
    components = {
      pipeline = {
        enable      = true
        description = "Pipeline generated by terraform harness provider"
        file        = "templates/dev/pipelines/packer-hashistack-gcp.tpl"
        tags        = ["component: packer", "cloud: gcp"]
        stages      = {}
        vars = {
          approver_ref  = "account.SE_Admin"
          git_connector = "infrateam_account"
        }
      }
      inputset = {
        gcp = {
          enable      = true
          file        = "templates/dev/inputsets/packer-hashistack-gcp_inputset.tpl"
          description = "Inputset generated by terraform harness provider"
          tags        = ["component: packer"]
          vars = {
            git_repo         = "learn-nomad-cluster-setup"
            docker_connector = "shared_services"
            GCP_PROJECT_ID   = "sales-209522"
            GCP_REGION       = "us-central1"
            GCP_ZONE         = "us-central1-a"
          }
        }
      }
      trigger = {}
    }
  }
  nomad_cluster_gcp = {
    project_ref = "hashicorp_stack_gcp"
    components = {
      pipeline = {
        enable      = true
        description = "Pipeline generated by terraform harness provider"
        file        = "templates/dev/pipelines/nomad_cluster_gcp.tpl"
        tags        = ["component: packer", "cloud: gcp"]
        stages = {
          terraform_sto_stage = {
            template_stage = true
            version        = "beta"
          }
        }
        vars = {
          approver_ref  = "account.SE_Admin"
          git_connector = "infrateam_account"
          tf_repo_name  = "learn-nomad-cluster-setup"
        }
      }
      inputset = {
        sto = {
          enable      = true
          file        = "templates/dev/inputsets/sto_nomad_cluster_inputset.tpl"
          description = "Inputset generated by terraform harness provider"
          tags        = ["component: nomad"]
          vars = {
            tf_folder         = "gcp"
            tf_backend_bucket = "crizstian-terraform"
            tf_workspace      = "<+trigger.sourceBranch>"
            harness_api_key   = "<+secrets.getValue(\"account.cristian_harness_platform_api_key\")>"
          }
        }
        apply = {
          enable      = true
          file        = "templates/dev/inputsets/nomad_cluster_gcp_inputset.tpl"
          description = "Inputset generated by terraform harness provider"
          tags        = ["component: nomad"]
          vars = {
            tf_folder         = "gcp"
            tf_backend_bucket = "crizstian-terraform"
            tf_workspace      = "<+trigger.sourceBranch>"
            tf_backend_prefix = "cristian_nomad_cluster"
            GCP_PROJECT_ID    = "sales-209522"
            GCP_REGION        = "us-central1"
            GCP_ZONE          = "us-central1-a"
            machine_image     = "hashistack-20230110025020"
          }
        }
      }
      trigger = {}
    }
  }
  packer_hashistack_aws = {
    project_ref = "hashicorp_stack_aws"
    components = {
      pipeline = {
        enable      = true
        description = "Pipeline generated by terraform harness provider"
        file        = "templates/dev/pipelines/packer-hashistack-aws.tpl"
        tags        = ["component: packer", "cloud: aws"]
        stages      = {}
        vars = {
          approver_ref  = "account.SE_Admin"
          git_connector = "infrateam_account"
        }
      }
      inputset = {
        aws = {
          enable      = true
          file        = "templates/dev/inputsets/packer-hashistack-aws_inputset.tpl"
          description = "Inputset generated by terraform harness provider"
          tags        = ["component: packer"]
          vars = {
            git_repo         = "learn-nomad-cluster-setup"
            docker_connector = "shared_services"
            AWS_REGION       = "us-east-1"
          }
        }
      }
      trigger = {}
    }
  }
  nomad_cluster_aws = {
    project_ref = "hashicorp_stack_aws"
    components = {
      pipeline = {
        enable      = true
        description = "Pipeline generated by terraform harness provider"
        file        = "templates/dev/pipelines/nomad_cluster_aws.tpl"
        tags        = ["component: packer", "cloud: aws"]
        stages = {
          terraform_sto_stage = {
            template_stage = true
            version        = "beta"
          }
        }
        vars = {
          approver_ref  = "account.SE_Admin"
          git_connector = "infrateam_account"
          tf_repo_name  = "learn-nomad-cluster-setup"
        }
      }
      inputset = {
        sto = {
          enable      = true
          file        = "templates/dev/inputsets/sto_nomad_cluster_inputset.tpl"
          description = "Inputset generated by terraform harness provider"
          tags        = ["component: nomad"]
          vars = {
            tf_folder         = "aws"
            tf_backend_bucket = "crizstian-terraform"
            tf_workspace      = "<+trigger.sourceBranch>"
            harness_api_key   = "<+secrets.getValue(\"account.cristian_harness_platform_api_key\")>"
          }
        }
        apply = {
          enable      = true
          file        = "templates/dev/inputsets/nomad_cluster_aws_inputset.tpl"
          description = "Inputset generated by terraform harness provider"
          tags        = ["component: nomad"]
          vars = {
            tf_folder         = "aws"
            tf_backend_bucket = "crizstian-terraform"
            tf_workspace      = "<+trigger.sourceBranch>"
            tf_backend_prefix = "cristian_nomad_cluster"
            AWS_REGION        = "us-east-1"
            machine_image     = "ami-054b4506582ac1dac"
          }
        }
      }
      trigger = {}
    }
  }
}
