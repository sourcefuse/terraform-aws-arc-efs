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
  default     = "replication-example"
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
