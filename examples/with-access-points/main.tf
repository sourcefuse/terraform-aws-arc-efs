################################################################################
## EFS with Access Points Example
################################################################################

# EFS with multiple access points
module "efs" {
  source = "../../"
  name   = var.name

  # EFS settings
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = var.encrypted

  # Mount targets configuration - using data sources for subnet IDs
  mount_targets = {
    "us-east-1a" = { subnet_id = data.aws_subnets.private.ids[0] }
    "us-east-1b" = { subnet_id = data.aws_subnets.private.ids[1] }
  }

  # Security group configuration - using data sources
  create_mount_target_security_group = var.create_mount_target_security_group
  mount_target_security_group_vpc_id = data.aws_vpc.default.id
  allowed_cidr_blocks                = [data.aws_vpc.default.cidr_block]

  #Access points for different applications/users
  access_points = var.access_points

  # Lifecycle policy to move files to IA after specified days
  lifecycle_policy = var.lifecycle_policy

  # Enable backup
  enable_backup_policy = var.enable_backup_policy

  tags = var.tags
}
