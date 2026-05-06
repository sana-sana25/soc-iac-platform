# =========================================================
# SOC-IAC PLATFORM
# TERRAFORM PROVIDERS
# =========================================================

terraform {

  required_version = ">= 1.5.0"

  required_providers {

    docker = {

      source  = "kreuzwerker/docker"

      version = "~> 3.0"

    }

  }

}

# =========================================================
# DOCKER PROVIDER
# =========================================================

provider "docker" {

  host = "unix:///var/run/docker.sock"

}

# =========================================================
# LOCAL VARIABLES
# =========================================================

locals {

  project_name = var.project_name

  environment = var.environment

  common_tags = {

    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"

  }

}