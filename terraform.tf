terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.56.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

  }
  required_version = ">= 0.14.9"
}
