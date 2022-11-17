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
  backend   = var.remote_state.backend
  workspace = var.remote_state.workspace

  config = {
    bucket = var.remote_state.config.bucket
    prefix = var.remote_state.config.prefix
  }
}
