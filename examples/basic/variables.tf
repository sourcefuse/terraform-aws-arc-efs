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

variable "create_mount_target_security_group" {
  type        = bool
  description = "Create security group for mount targets"
  default     = true
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
