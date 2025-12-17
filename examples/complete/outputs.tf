################################################################################
## Complete Example Outputs
################################################################################

# EFS File System Outputs
output "efs_id" {
  description = "ID of the EFS file system"
  value       = module.efs.efs_id
}

output "efs_arn" {
  description = "ARN of the EFS file system"
  value       = module.efs.efs_arn
}

output "efs_dns_name" {
  description = "DNS name of the EFS file system"
  value       = module.efs.efs_dns_name
}

output "efs_creation_token" {
  description = "Creation token of the EFS file system"
  value       = module.efs.efs_creation_token
}

# Mount Targets
output "mount_targets" {
  description = "Mount targets information"
  value       = module.efs.mount_targets
}

output "mount_target_dns_names" {
  description = "DNS names for mount targets"
  value       = module.efs.mount_target_dns_names
}

# Security Group
output "security_group_id" {
  description = "Security group ID for mount targets"
  value       = module.efs.security_group_id
}

output "security_group_arn" {
  description = "Security group ARN for mount targets"
  value       = module.efs.security_group_arn
}

# Access Points
output "access_points" {
  description = "Access points created"
  value       = module.efs.access_points
}

output "access_point_ids" {
  description = "List of access point IDs"
  value       = module.efs.access_point_ids
}

output "access_point_arns" {
  description = "List of access point ARNs"
  value       = module.efs.access_point_arns
}

# Replication
output "replication_configuration_id" {
  description = "ID of the replication configuration"
  value       = module.efs.replication_configuration_id
}

output "replication_destination_file_system_id" {
  description = "The file system ID of the replica"
  value       = module.efs.replication_configuration_destination_file_system_id
}

# Backup Policy
output "backup_policy_id" {
  description = "ID of the backup policy"
  value       = module.efs.backup_policy_id
}

# KMS Key (from module)
output "kms_key_id" {
  description = "ID of the KMS key used for EFS encryption"
  value       = var.kms_key_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for EFS encryption"
  value       = var.kms_key_id
}

# Complete Configuration Reference
output "complete_efs_config" {
  description = "Complete EFS configuration for reference"
  value       = module.efs.complete_efs_config
}
