################################################################################
## Complete EFS Example - All Features
################################################################################

# Complete EFS configuration with all features
module "efs" {
  source = "../../"
  name   = var.name

  # Custom creation token
  creation_token = var.creation_token

  # High-performance configuration
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_mibps

  # Encryption with custom KMS key
  encrypted  = var.encrypted
  kms_key_id = var.kms_key_id

  # Mount targets configuration - using data sources for subnet IDs across multiple AZs
  mount_targets = {
    "us-east-1a" = { subnet_id = data.aws_subnets.private.ids[0] }
    "us-east-1b" = { subnet_id = data.aws_subnets.private.ids[1] }
  }

  # Security group configuration - using data sources
  create_mount_target_security_group      = var.create_mount_target_security_group
  mount_target_security_group_name        = var.mount_target_security_group_name
  mount_target_security_group_description = var.mount_target_security_group_description
  mount_target_security_group_vpc_id      = data.aws_vpc.default.id
  allowed_cidr_blocks                     = [data.aws_vpc.default.cidr_block]
  allowed_security_group_ids              = var.allowed_security_group_ids

  # Multiple access points for different use cases
  access_points = var.access_points

  # Lifecycle policy for cost optimization
  lifecycle_policy = var.lifecycle_policy

  # Cross-region replication for disaster recovery
  # IMPORTANT: By AWS design, when replication is deleted (during 'terraform destroy'),
  # the replicated destination EFS becomes a standalone, writeable file system rather
  # than being automatically deleted. This is an AWS safety feature to prevent data loss,
  # but it means the destination EFS continues to incur charges unless manually cleaned up.
  # Check the destination region after destroy and delete the EFS if no longer needed.
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
