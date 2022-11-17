terraform {
  required_providers {
    harness = {
      source = "harness/harness"
    }
  }

  backend "gcs" {}
}

provider "harness" {}

resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
}

data "terraform_remote_state" "harness" {
  backend   = "gcs"
  workspace = "cristian"
  config = {
    bucket = "crizstian-terraform"
    prefix = "cristian-lab-devsecops-org"
  }
}
