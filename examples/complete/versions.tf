################################################################################
## Terraform and Provider Version Requirements
################################################################################
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#Provider for replication destination region
provider "aws" {
  alias  = "replica"
  region = var.replication_region
}
