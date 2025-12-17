################################################################################
## Local Values
################################################################################
locals {
  name = var.name

  # Mount target security group name
  mount_target_sg_name = var.mount_target_security_group_name != null ? var.mount_target_security_group_name : "${local.name}-mt"
}

################################################################################
## EFS File System
################################################################################
resource "aws_efs_file_system" "this" {
  availability_zone_name = var.availability_zone_name
  creation_token         = var.creation_token != null ? var.creation_token : local.name
  encrypted              = var.encrypted
  kms_key_id             = var.kms_key_id
  performance_mode       = var.performance_mode
  throughput_mode        = var.throughput_mode

  provisioned_throughput_in_mibps = var.throughput_mode == "provisioned" ? var.provisioned_throughput_in_mibps : null

  # Lifecycle policies
  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy.transition_to_ia != null ? [1] : []
    content {
      transition_to_ia = var.lifecycle_policy.transition_to_ia
    }
  }

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy.transition_to_primary_storage_class != null ? [1] : []
    content {
      transition_to_primary_storage_class = var.lifecycle_policy.transition_to_primary_storage_class
    }
  }

  tags = var.tags
}

################################################################################
## EFS Backup Policy
################################################################################
resource "aws_efs_backup_policy" "this" {
  count = var.enable_backup_policy ? 1 : 0

  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "ENABLED"
  }
}

################################################################################
## EFS Lifecycle Configuration
################################################################################
resource "aws_efs_file_system_policy" "this" {
  count = var.policy != null ? 1 : 0

  file_system_id = aws_efs_file_system.this.id
  policy         = var.policy

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
}


################################################################################
## Mount Target Security Group
################################################################################
resource "aws_security_group" "mount_target" {
  count = var.create_mount_target_security_group ? 1 : 0

  name_prefix = "${local.mount_target_sg_name}-"
  description = var.mount_target_security_group_description
  vpc_id      = var.mount_target_security_group_vpc_id

  tags = merge(var.tags, {
    Name = local.mount_target_sg_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
## Mount Target Security Group Rules - NFS Ingress from CIDR blocks
################################################################################
resource "aws_security_group_rule" "nfs_ingress_cidr" {
  count = var.create_mount_target_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.mount_target[0].id
  description       = "NFS ingress from CIDR blocks"
}

################################################################################
## Mount Target Security Group Rules - NFS Ingress from Security Groups
################################################################################
resource "aws_security_group_rule" "nfs_ingress_sg" {
  count = var.create_mount_target_security_group && length(var.allowed_security_group_ids) > 0 ? length(var.allowed_security_group_ids) : 0

  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_group_ids[count.index]
  security_group_id        = aws_security_group.mount_target[0].id
  description              = "NFS ingress from security group ${var.allowed_security_group_ids[count.index]}"
}

################################################################################
## Additional Security Group Rules
################################################################################
resource "aws_security_group_rule" "additional" {
  for_each = var.create_mount_target_security_group ? var.additional_security_group_rules : {}

  security_group_id = aws_security_group.mount_target[0].id

  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  prefix_list_ids          = each.value.prefix_list_ids
  source_security_group_id = each.value.security_groups != null && length(each.value.security_groups) > 0 ? each.value.security_groups[0] : null
  self                     = each.value.self
  description              = each.value.description
}

################################################################################
## EFS Mount Targets
################################################################################
resource "aws_efs_mount_target" "this" {
  for_each = var.mount_targets

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value.subnet_id
  security_groups = length(each.value.security_groups) > 0 ? each.value.security_groups : (var.create_mount_target_security_group ? [aws_security_group.mount_target[0].id] : [])
}

################################################################################
## EFS Access Points
################################################################################
resource "aws_efs_access_point" "this" {
  for_each = var.access_points

  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = each.value.path

    dynamic "creation_info" {
      for_each = each.value.creation_info != null ? [each.value.creation_info] : []
      content {
        owner_gid   = creation_info.value.owner_gid
        owner_uid   = creation_info.value.owner_uid
        permissions = creation_info.value.permissions
      }
    }
  }

  dynamic "posix_user" {
    for_each = each.value.posix_user != null ? [each.value.posix_user] : []
    content {
      gid            = posix_user.value.gid
      uid            = posix_user.value.uid
      secondary_gids = posix_user.value.secondary_gids
    }
  }

  tags = merge(var.tags, each.value.tags, {
    Name = "${local.name}-ap-${each.key}"
  })
}

################################################################################
## EFS Replication Configuration
################################################################################
resource "aws_efs_replication_configuration" "this" {
  count = var.replication_configuration != null ? 1 : 0

  source_file_system_id = aws_efs_file_system.this.id

  destination {
    region                 = var.replication_configuration.destination.region
    availability_zone_name = var.replication_configuration.destination.availability_zone_name
    kms_key_id             = var.replication_configuration.destination.kms_key_id
  }
}
