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

output "replication_configuration_id" {
  description = "ID of the replication configuration"
  value       = module.efs.replication_configuration_id
}

output "replication_destination_file_system_id" {
  description = "The file system ID of the replica"
  value       = module.efs.replication_configuration_destination_file_system_id
}

output "mount_targets" {
  description = "Mount targets information"
  value       = module.efs.mount_targets
}

output "security_group_id" {
  description = "Security group ID for mount targets"
  value       = module.efs.security_group_id
}
