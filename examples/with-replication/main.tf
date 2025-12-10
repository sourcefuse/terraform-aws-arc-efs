################################################################################
## EFS with Cross-Region Replication Example
################################################################################

# EFS with cross-region replication for disaster recovery
module "efs" {
  source = "../../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name

  # High-performance EFS settings for production workload
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_mibps
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id

  # Mount targets configuration
  mount_targets = var.mount_targets

  #Security group configuration
  create_mount_target_security_group = var.create_mount_target_security_group
  mount_target_security_group_vpc_id = var.mount_target_security_group_vpc_id
  allowed_cidr_blocks                = var.allowed_cidr_blocks
  allowed_security_group_ids         = var.allowed_security_group_ids

  # Cross-region replication for disaster recovery
  replication_configuration = var.replication_configuration

  # Lifecycle policy for cost optimization
  lifecycle_policy = var.lifecycle_policy

  # Enable backup policy
  enable_backup_policy = var.enable_backup_policy

  # Additional security group rules for specific access patterns
  additional_security_group_rules = var.additional_security_group_rules

  tags = var.tags
}
