provider "google" {
  project = "prism-prod-372103"
  region  = "asia-northeast1"
}

terraform {
  backend "s3" {
    bucket = "irofessional-main-tfstate"
    key    = "prism-api-infra/terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.55.0"
    }
  }
}