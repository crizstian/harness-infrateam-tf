resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
}

data "terraform_remote_state" "onboarding" {
  backend   = var.remote_state.backend
  workspace = "infrateam"

  config = {
    bucket = var.remote_state.config.bucket
    prefix = var.remote_state.config.prefix
  }
}

data "terraform_remote_state" "remote" {
  backend   = var.remote_state.backend
  workspace = "shared_services"

  config = {
    bucket = var.remote_state.config.bucket
    prefix = var.remote_state.config.prefix
  }
}
