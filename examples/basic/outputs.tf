output "efs_id" {
  description = "ID of the EFS file system"
  value       = module.efs.efs_id
}

output "efs_dns_name" {
  description = "DNS name of the EFS file system"
  value       = module.efs.efs_dns_name
}

output "mount_targets" {
  description = "Mount targets information"
  value       = module.efs.mount_targets
}

output "security_group_id" {
  description = "Security group ID for mount targets"
  value       = module.efs.security_group_id
}
