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
