################################################################################
## Complete EFS Example - All Features
################################################################################

# Complete EFS configuration with all features
module "efs" {
  source = "../../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name

  # Custom creation token
  creation_token = var.creation_token

  # High-performance configuration
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_mibps

  # Encryption with custom KMS key
  encrypted  = var.encrypted
  kms_key_id = var.kms_key_id

  # Mount targets configuration
  mount_targets = var.mount_targets

  # Security group configuration
  create_mount_target_security_group      = var.create_mount_target_security_group
  mount_target_security_group_name        = var.mount_target_security_group_name
  mount_target_security_group_description = var.mount_target_security_group_description
  mount_target_security_group_vpc_id      = var.mount_target_security_group_vpc_id
  allowed_cidr_blocks                     = var.allowed_cidr_blocks
  allowed_security_group_ids              = var.allowed_security_group_ids

  # Multiple access points for different use cases
  access_points = var.access_points

  # Lifecycle policy for cost optimization
  lifecycle_policy = var.lifecycle_policy

  # Cross-region replication for disaster recovery
  replication_configuration = var.replication_configuration

  # Enable backup policy
  enable_backup_policy = var.enable_backup_policy

  # Custom file system policy for access control
  policy                             = var.policy
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check

  # Additional security group rules
  additional_security_group_rules = var.additional_security_group_rules

  tags = var.tags
}
