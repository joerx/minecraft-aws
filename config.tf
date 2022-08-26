terraform {
  cloud {
    organization = "joerx"

    workspaces {
      name = "minecraft-tf"
    }
  }

  required_providers {
    aws   = "~> 4.0"
    local = "~> 2.2"
    tls   = "~> 4.0"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}
