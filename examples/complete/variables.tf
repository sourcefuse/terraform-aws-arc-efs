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
  default     = "complete-example"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "replication_region" {
  type        = string
  description = "aws region for replication"
  default     = "us-east-2"
}

variable "creation_token" {
  type        = string
  description = "Unique token for EFS creation"
  default     = "arc-prod-complete-example-token"
}

variable "performance_mode" {
  type        = string
  description = "EFS performance mode"
  default     = "maxIO"
}

variable "throughput_mode" {
  type        = string
  description = "EFS throughput mode"
  default     = "provisioned"
}

variable "provisioned_throughput_mibps" {
  type        = number
  description = "Provisioned throughput in MiBps"
  default     = 1000
}

variable "encrypted" {
  type        = bool
  description = "Enable EFS encryption"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ID for encryption (will be created by separate KMS module)"
  default     = null
}

variable "mount_targets" {
  type = map(object({
    subnet_id = string
  }))
  description = "Mount targets configuration"
  default = {
    us-east-1a = { subnet_id = "subnet-066d0c78479b72e77" }
    us-east-1b = { subnet_id = "subnet-0c55ffb1f4a8bd7c2" }
    us-east-1c = { subnet_id = "subnet-064b80a494fed9835" }
    us-east-1d = { subnet_id = "subnet-01efab943d2bbe156" }
  }
}

variable "create_mount_target_security_group" {
  type        = bool
  description = "Create security group for mount targets"
  default     = true
}

variable "mount_target_security_group_name" {
  type        = string
  description = "Name for the mount target security group"
  default     = "arc-prod-complete-example-efs-sg"
}

variable "mount_target_security_group_description" {
  type        = string
  description = "Description for the mount target security group"
  default     = "Security group for EFS mount targets - Complete Example"
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

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security group IDs allowed to access EFS"
  default     = []
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
    app_data = {
      path = "/app/data"
      creation_info = {
        owner_gid   = 1001
        owner_uid   = 1001
        permissions = "755"
      }
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1010, 1011]
      }
      tags = {
        Application = "WebApp"
        DataType    = "ApplicationData"
      }
    }
    database = {
      path = "/database"
      creation_info = {
        owner_gid   = 999
        owner_uid   = 999
        permissions = "750"
      }
      posix_user = {
        gid            = 999
        uid            = 999
        secondary_gids = []
      }
      tags = {
        Application = "Database"
        DataType    = "DatabaseFiles"
      }
    }
    logs = {
      path = "/logs"
      creation_info = {
        owner_gid   = 1002
        owner_uid   = 1002
        permissions = "755"
      }
      posix_user = {
        gid            = 1002
        uid            = 1002
        secondary_gids = []
      }
      tags = {
        Purpose  = "LogStorage"
        DataType = "ApplicationLogs"
      }
    }
    backup = {
      path = "/backup"
      creation_info = {
        owner_gid   = 1003
        owner_uid   = 1003
        permissions = "700"
      }
      posix_user = {
        gid            = 1003
        uid            = 1003
        secondary_gids = []
      }
      tags = {
        Purpose   = "Backup"
        DataType  = "BackupData"
        Retention = "LongTerm"
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

variable "replication_configuration" {
  type = object({
    destination = object({
      region     = string
      kms_key_id = string
    })
  })
  description = "Cross-region replication configuration"
  default = {
    destination = {
      region     = "us-east-2"
      kms_key_id = null
    }
  }
}

variable "enable_backup_policy" {
  type        = bool
  description = "Enable EFS backup policy"
  default     = true
}

variable "policy" {
  type        = string
  description = "EFS file system policy JSON"
  default     = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"elasticfilesystem:ClientMount\",\"elasticfilesystem:ClientWrite\",\"elasticfilesystem:ClientRootAccess\"],\"Resource\":\"*\",\"Condition\":{\"Bool\":{\"aws:SecureTransport\":\"true\"}}}]}"
}

variable "bypass_policy_lockout_safety_check" {
  type        = bool
  description = "Bypass policy lockout safety check"
  default     = false
}

variable "additional_security_group_rules" {
  type = map(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  description = "Additional security group rules"
  default = {
    management_access = {
      type        = "ingress"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      cidr_blocks = ["10.0.100.0/24"]
      description = "NFS access from management subnet"
    }
    health_check_egress = {
      type        = "egress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS egress for health checks"
    }
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Project         = "ARC"
    Example         = "Complete"
    Environment     = "prod"
    Namespace       = "arc"
    Compliance      = "SOC2"
    BackupStrategy  = "CrossRegion"
    CostOptimized   = "true"
    MonitoringLevel = "Enhanced"
    DataClass       = "Sensitive"
  }
}
