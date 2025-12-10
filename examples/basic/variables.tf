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
  default     = "dev"
}

variable "name" {
  type        = string
  description = "Name of the EFS file system"
  default     = "basic-example"
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
  default     = "bursting"
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
    Example     = "Basic"
    Environment = "dev"
    Namespace   = "arc"
  }
}
