################################################################################
## EFS File System Outputs
################################################################################
output "efs_id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.this.id
}

output "efs_arn" {
  description = "ARN of the EFS file system"
  value       = aws_efs_file_system.this.arn
}

output "efs_dns_name" {
  description = "DNS name of the EFS file system"
  value       = aws_efs_file_system.this.dns_name
}

output "efs_creation_token" {
  description = "Creation token of the EFS file system"
  value       = aws_efs_file_system.this.creation_token
}

output "efs_performance_mode" {
  description = "Performance mode of the EFS file system"
  value       = aws_efs_file_system.this.performance_mode
}

output "efs_throughput_mode" {
  description = "Throughput mode of the EFS file system"
  value       = aws_efs_file_system.this.throughput_mode
}

output "efs_encrypted" {
  description = "Whether the EFS file system is encrypted"
  value       = aws_efs_file_system.this.encrypted
}

output "efs_kms_key_id" {
  description = "The ARN for the KMS encryption key used to encrypt the EFS file system"
  value       = aws_efs_file_system.this.kms_key_id
}

output "efs_size_in_bytes" {
  description = "Current byte count used by the file system"
  value       = aws_efs_file_system.this.size_in_bytes
}

output "efs_owner_id" {
  description = "AWS account ID that created the file system"
  value       = aws_efs_file_system.this.owner_id
}

################################################################################
## Mount Target Outputs
################################################################################
output "mount_targets" {
  description = "Map of mount targets created"
  value = {
    for k, v in aws_efs_mount_target.this : k => {
      id                = v.id
      dns_name          = v.dns_name
      network_interface = v.network_interface_id
      subnet_id         = v.subnet_id
      availability_zone = v.availability_zone_name
      ip_address        = v.ip_address
    }
  }
}

output "mount_target_ids" {
  description = "List of mount target IDs"
  value       = values(aws_efs_mount_target.this)[*].id
}

output "mount_target_dns_names" {
  description = "List of mount target DNS names"
  value       = values(aws_efs_mount_target.this)[*].dns_name
}

output "mount_target_network_interface_ids" {
  description = "List of mount target network interface IDs"
  value       = values(aws_efs_mount_target.this)[*].network_interface_id
}

################################################################################
## Security Group Outputs
################################################################################
output "security_group_id" {
  description = "ID of the mount target security group"
  value       = var.create_mount_target_security_group ? aws_security_group.mount_target[0].id : null
}

output "security_group_arn" {
  description = "ARN of the mount target security group"
  value       = var.create_mount_target_security_group ? aws_security_group.mount_target[0].arn : null
}

output "security_group_name" {
  description = "Name of the mount target security group"
  value       = var.create_mount_target_security_group ? aws_security_group.mount_target[0].name : null
}

################################################################################
## Access Point Outputs
################################################################################
output "access_points" {
  description = "Map of access points created"
  value = {
    for k, v in aws_efs_access_point.this : k => {
      id              = v.id
      arn             = v.arn
      owner_id        = v.owner_id
      file_system_arn = v.file_system_arn
      file_system_id  = v.file_system_id
    }
  }
}

output "access_point_ids" {
  description = "List of access point IDs"
  value       = values(aws_efs_access_point.this)[*].id
}

output "access_point_arns" {
  description = "List of access point ARNs"
  value       = values(aws_efs_access_point.this)[*].arn
}

################################################################################
## Backup Policy Output
################################################################################
output "backup_policy_id" {
  description = "ID of the backup policy"
  value       = var.enable_backup_policy ? aws_efs_backup_policy.this[0].id : null
}

################################################################################
## Replication Configuration Output
################################################################################
output "replication_configuration_id" {
  description = "ID of the replication configuration"
  value       = var.replication_configuration != null ? aws_efs_replication_configuration.this[0].id : null
}

output "replication_configuration_destination_file_system_id" {
  description = "The file system ID of the replica"
  value       = var.replication_configuration != null ? aws_efs_replication_configuration.this[0].destination[0].file_system_id : null
}

################################################################################
## Complete Configuration Outputs
################################################################################
output "complete_efs_config" {
  description = "Complete EFS configuration for reference"
  value = {
    file_system = {
      id               = aws_efs_file_system.this.id
      arn              = aws_efs_file_system.this.arn
      dns_name         = aws_efs_file_system.this.dns_name
      creation_token   = aws_efs_file_system.this.creation_token
      performance_mode = aws_efs_file_system.this.performance_mode
      throughput_mode  = aws_efs_file_system.this.throughput_mode
      encrypted        = aws_efs_file_system.this.encrypted
      kms_key_id       = aws_efs_file_system.this.kms_key_id
    }
    mount_targets = {
      for k, v in aws_efs_mount_target.this : k => {
        id                = v.id
        dns_name          = v.dns_name
        network_interface = v.network_interface_id
        subnet_id         = v.subnet_id
        availability_zone = v.availability_zone_name
        ip_address        = v.ip_address
      }
    }
    access_points = {
      for k, v in aws_efs_access_point.this : k => {
        id  = v.id
        arn = v.arn
      }
    }
    security_group_id   = var.create_mount_target_security_group ? aws_security_group.mount_target[0].id : null
    backup_enabled      = var.enable_backup_policy
    replication_enabled = var.replication_configuration != null
  }
}
