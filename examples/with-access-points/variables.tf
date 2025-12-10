################################################################################
## General Variables
################################################################################
variable "namespace" {
  type        = string
  description = "Namespace for the resources"
  default     = "arc"
}

variable "environment" {
  type        = string
  description = "Environment identifier (e.g., dev, staging, prod)"
  default     = "prod"
}

variable "name" {
  type        = string
  description = "Name of the EFS file system"
  default     = "access-points-example"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "performance_mode" {
  type        = string
  description = "EFS performance mode"
  default     = "generalPurpose"
}

variable "throughput_mode" {
  type        = string
  description = "EFS throughput mode"
  default     = "elastic"
}

variable "encrypted" {
  type        = bool
  description = "Whether to encrypt the EFS file system"
  default     = true
}

variable "mount_targets" {
  type = map(object({
    subnet_id = string
  }))
  description = "Mount targets configuration"
  default = {
    us-east-1a = { subnet_id = "subnet-066d0c78479b72e77" }
    us-east-1b = { subnet_id = "subnet-0c55ffb1f4a8bd7c2" }
  }
}

variable "create_mount_target_security_group" {
  type        = bool
  description = "Create security group for mount targets"
  default     = true
}

variable "mount_target_security_group_vpc_id" {
  type        = string
  description = "VPC ID for the security group"
  default     = "vpc-0e6c09980580ecbf6"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access EFS"
  default     = ["10.12.0.0/16"]
}

variable "access_points" {
  type = map(object({
    path = string
    creation_info = object({
      owner_gid   = number
      owner_uid   = number
      permissions = string
    })
    posix_user = object({
      gid            = number
      uid            = number
      secondary_gids = list(number)
    })
    tags = map(string)
  }))
  description = "EFS access points configuration"
  default = {
    web_app = {
      path = "/web"
      creation_info = {
        owner_gid   = 1001
        owner_uid   = 1001
        permissions = "755"
      }
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = []
      }
      tags = {
        Application = "WebApp"
      }
    }
    db_backup = {
      path = "/database/backups"
      creation_info = {
        owner_gid   = 1002
        owner_uid   = 1002
        permissions = "750"
      }
      posix_user = {
        gid            = 1002
        uid            = 1002
        secondary_gids = []
      }
      tags = {
        Application = "Database"
        Purpose     = "Backup"
      }
    }
    shared = {
      path = "/shared"
      creation_info = {
        owner_gid   = 1000
        owner_uid   = 1000
        permissions = "777"
      }
      posix_user = {
        gid            = 1000
        uid            = 1000
        secondary_gids = []
      }
      tags = {
        Purpose = "SharedStorage"
      }
    }
  }
}

variable "lifecycle_policy" {
  type = object({
    transition_to_ia                    = string
    transition_to_primary_storage_class = string
  })
  description = "EFS lifecycle policy"
  default = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
}

variable "enable_backup_policy" {
  type        = bool
  description = "Whether to enable EFS backup policy"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Project     = "ARC"
    Example     = "AccessPoints"
    Environment = "prod"
    Namespace   = "arc"
  }
}
