################################################################################
## Basic EFS Example
################################################################################

# Basic EFS configuration
module "efs" {
  source = "../../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name

  # Basic EFS settings
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = var.encrypted

  # Mount targets configuration
  mount_targets = var.mount_targets

  # Security group configuration
  create_mount_target_security_group = var.create_mount_target_security_group
  mount_target_security_group_vpc_id = var.mount_target_security_group_vpc_id
  allowed_cidr_blocks                = var.allowed_cidr_blocks

  # Enable backup policy
  enable_backup_policy = var.enable_backup_policy

  tags = var.tags
}
