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
  default     = "poc"
}

variable "name" {
  type        = string
  description = "Name of the EFS file system"
  default     = "replication-example"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
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
  default     = 500
}

variable "encrypted" {
  type        = bool
  description = "Whether to encrypt the EFS file system"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ID for encryption"
  default     = null
}

variable "create_mount_target_security_group" {
  type        = bool
  description = "Create security group for mount targets"
  default     = true
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security group IDs allowed to access EFS"
  default     = []
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

variable "lifecycle_policy" {
  type = object({
    transition_to_ia = string
  })
  description = "EFS lifecycle policy"
  default = {
    transition_to_ia = "AFTER_7_DAYS"
  }
}

variable "enable_backup_policy" {
  type        = bool
  description = "Whether to enable EFS backup policy"
  default     = true
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
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Project        = "ARC"
    Example        = "Replication"
    Environment    = "prod"
    Namespace      = "arc"
    BackupStrategy = "CrossRegion"
    Compliance     = "Required"
  }
}
