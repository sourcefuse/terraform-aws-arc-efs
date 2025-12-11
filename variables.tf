################################################################################
## General Variables
################################################################################
variable "name" {
  type        = string
  description = "Name of the EFS file system"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`)"
  default     = {}
}

################################################################################
## EFS File System Variables
################################################################################
variable "availability_zone_name" {
  type        = string
  description = "AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes"
  default     = null
}

variable "creation_token" {
  type        = string
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the EFS"
  default     = null
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  default     = "generalPurpose"
  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "Performance mode must be either 'generalPurpose' or 'maxIO'."
  }
}

variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `elastic`, `provisioned`"
  default     = "bursting"
  validation {
    condition     = contains(["bursting", "elastic", "provisioned"], var.throughput_mode)
    error_message = "Throughput mode must be one of: 'bursting', 'elastic', 'provisioned'."
  }
}

variable "provisioned_throughput_in_mibps" {
  type        = number
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned"
  default     = null
}

variable "encrypted" {
  type        = bool
  description = "If true, the disk will be encrypted"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true"
  default     = null
}

################################################################################
## EFS Backup Policy
################################################################################
variable "enable_backup_policy" {
  type        = bool
  description = "A boolean that indicates whether or not to apply Backup Policy to the file system"
  default     = true
}

################################################################################
## EFS Lifecycle Configuration
################################################################################
variable "lifecycle_policy" {
  type = object({
    transition_to_ia                    = optional(string)
    transition_to_primary_storage_class = optional(string)
  })
  description = "A file system lifecycle policy object"
  default     = {}
  validation {
    condition = alltrue([
      var.lifecycle_policy.transition_to_ia == null ? true : contains([
        "AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS"
      ], var.lifecycle_policy.transition_to_ia),
      var.lifecycle_policy.transition_to_primary_storage_class == null ? true : contains([
        "AFTER_1_ACCESS"
      ], var.lifecycle_policy.transition_to_primary_storage_class)
    ])
    error_message = "Invalid lifecycle policy values. transition_to_ia must be one of: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS. transition_to_primary_storage_class must be: AFTER_1_ACCESS"
  }
}

################################################################################
## Mount Targets
################################################################################
variable "mount_targets" {
  type = map(object({
    subnet_id       = string
    security_groups = optional(list(string), [])
  }))
  description = "A map of mount target configurations where key is the AZ name"
  default     = {}
}

variable "create_mount_target_security_group" {
  type        = bool
  description = "Create a security group for mount targets"
  default     = true
}

variable "mount_target_security_group_name" {
  type        = string
  description = "Name of the mount target security group"
  default     = null
}

variable "mount_target_security_group_description" {
  type        = string
  description = "Description of the mount target security group"
  default     = "EFS mount target security group"
}

variable "mount_target_security_group_vpc_id" {
  type        = string
  description = "ID of the VPC where mount target security group will be created"
  default     = null
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access EFS"
  default     = []
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs allowed to access EFS"
  default     = []
}

################################################################################
## EFS Access Points
################################################################################
variable "access_points" {
  type = map(object({
    path = optional(string, "/")
    creation_info = optional(object({
      owner_gid   = number
      owner_uid   = number
      permissions = string
    }))
    posix_user = optional(object({
      gid            = number
      uid            = number
      secondary_gids = optional(list(number))
    }))
    tags = optional(map(string), {})
  }))
  description = "A map of EFS access points to create"
  default     = {}
}

################################################################################
## EFS File System Policy
################################################################################
variable "policy" {
  type        = string
  description = "A valid JSON formatted policy for the EFS file system"
  default     = null
}

variable "bypass_policy_lockout_safety_check" {
  type        = bool
  description = "A flag to indicate whether to bypass the aws_efs_file_system_policy lockout safety check"
  default     = false
}

################################################################################
## EFS Replication Configuration
################################################################################
variable "replication_configuration" {
  type = object({
    destination = object({
      region                 = optional(string)
      availability_zone_name = optional(string)
      kms_key_id             = optional(string)
    })
  })
  description = "A map of replication configuration"
  default     = null
}

################################################################################
## Additional Security Groups Configuration
################################################################################
variable "additional_security_group_rules" {
  type = map(object({
    type             = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
    description      = optional(string)
  }))
  description = "A map of additional security group rules to add to the mount target security group"
  default     = {}
}
