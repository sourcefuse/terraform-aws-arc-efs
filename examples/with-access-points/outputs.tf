output "efs_id" {
  description = "ID of the EFS file system"
  value       = module.efs.efs_id
}

output "efs_dns_name" {
  description = "DNS name of the EFS file system"
  value       = module.efs.efs_dns_name
}

output "access_points" {
  description = "Access points created"
  value       = module.efs.access_points
}

output "access_point_ids" {
  description = "List of access point IDs"
  value       = module.efs.access_point_ids
}

output "mount_targets" {
  description = "Mount targets information"
  value       = module.efs.mount_targets
}
