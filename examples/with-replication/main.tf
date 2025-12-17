################################################################################
## EFS with Cross-Region Replication Example
################################################################################

# EFS with cross-region replication for disaster recovery
module "efs" {
  source = "../../"
  name   = var.name

  # High-performance EFS settings for production workload
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_mibps
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id

  # Mount targets configuration - using data sources for subnet IDs
  mount_targets = {
    "us-east-1a" = { subnet_id = data.aws_subnets.private.ids[0] }
    "us-east-1b" = { subnet_id = data.aws_subnets.private.ids[1] }
  }

  # Security group configuration - using data sources
  create_mount_target_security_group = var.create_mount_target_security_group
  mount_target_security_group_vpc_id = data.aws_vpc.default.id
  allowed_cidr_blocks                = [data.aws_vpc.default.cidr_block]
  allowed_security_group_ids         = var.allowed_security_group_ids

  # Cross-region replication for disaster recovery
  # IMPORTANT: By AWS design, when replication is deleted (during 'terraform destroy'),
  # the replicated destination EFS becomes a standalone, writeable file system rather
  # than being automatically deleted. This is an AWS safety feature to prevent data loss,
  # but it means the destination EFS continues to incur charges unless manually cleaned up.
  # Check the destination region after destroy and delete the EFS if no longer needed.
  replication_configuration = var.replication_configuration

  # Lifecycle policy for cost optimization
  lifecycle_policy = var.lifecycle_policy

  # Enable backup policy
  enable_backup_policy = var.enable_backup_policy

  # Additional security group rules for specific access patterns
  additional_security_group_rules = var.additional_security_group_rules

  tags = var.tags
}
