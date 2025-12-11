# EFS with Access Points Example

This example demonstrates how to create an EFS file system with multiple access points for different applications or users, providing isolated and secure access to specific directories.

## Overview

This example creates:
- An EFS file system with elastic throughput mode for automatic scaling
- Multiple mount targets across 3 availability zones
- Three access points with different configurations:
  - **Web Application**: `/web` directory with application-specific permissions
  - **Database Backup**: `/database/backups` with restricted access
  - **Shared Storage**: `/shared` with broad access permissions
- Lifecycle policy for cost optimization (files moved to IA after 30 days)
- Security group with CIDR-based access control

## Features

- **Access Points**: Isolated access to specific file system paths
- **POSIX Permissions**: User/group ID enforcement at the NFS level
- **Elastic Throughput**: Automatic scaling based on workload
- **Multi-AZ Setup**: Mount targets in 3 availability zones
- **Cost Optimization**: Lifecycle policy for intelligent tiering
- **Directory Creation**: Automatic directory creation with proper ownership
- **Secure Access**: Application-specific access controls

## Use Cases

### Web Application Storage
- **Path**: `/web`
- **User/Group**: 1001:1001
- **Permissions**: 755 (read/write for owner, read for others)
- **Use Case**: Application files, uploads, cache

### Database Backup Storage
- **Path**: `/database/backups`
- **User/Group**: 1002:1002
- **Permissions**: 750 (read/write for owner, read for group)
- **Use Case**: Database dumps, backup files

### Shared Storage
- **Path**: `/shared`
- **User/Group**: 1000:1000
- **Permissions**: 777 (full access for all)
- **Use Case**: Shared documents, temporary files

## Usage

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5 installed
- Default VPC with at least 3 subnets in different AZs

### Quick Start

1. **Clone and Navigate**
   ```bash
   git clone <repository-url>
   cd examples/with-access-points
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Customize Variables** (Optional)
   ```bash
   # Create terraform.tfvars file
   cat > terraform.tfvars <<EOF
   namespace   = "my-company"
   environment = "prod"
   name        = "multi-app-storage"

   # Override access point configurations
   web_app_uid = 1001
   web_app_gid = 1001
   db_backup_uid = 1002
   db_backup_gid = 1002

   additional_tags = {
     Owner = "Platform Team"
     CostCenter = "Engineering"
   }
   EOF
   ```

4. **Plan and Apply**
   ```bash
   terraform plan
   terraform apply
   ```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs"></a> [efs](#module\_efs) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_points"></a> [access\_points](#input\_access\_points) | EFS access points configuration | <pre>map(object({<br/>    path = string<br/>    creation_info = object({<br/>      owner_gid   = number<br/>      owner_uid   = number<br/>      permissions = string<br/>    })<br/>    posix_user = object({<br/>      gid            = number<br/>      uid            = number<br/>      secondary_gids = list(number)<br/>    })<br/>    tags = map(string)<br/>  }))</pre> | <pre>{<br/>  "db_backup": {<br/>    "creation_info": {<br/>      "owner_gid": 1002,<br/>      "owner_uid": 1002,<br/>      "permissions": "750"<br/>    },<br/>    "path": "/database/backups",<br/>    "posix_user": {<br/>      "gid": 1002,<br/>      "secondary_gids": [],<br/>      "uid": 1002<br/>    },<br/>    "tags": {<br/>      "Application": "Database",<br/>      "Purpose": "Backup"<br/>    }<br/>  },<br/>  "shared": {<br/>    "creation_info": {<br/>      "owner_gid": 1000,<br/>      "owner_uid": 1000,<br/>      "permissions": "777"<br/>    },<br/>    "path": "/shared",<br/>    "posix_user": {<br/>      "gid": 1000,<br/>      "secondary_gids": [],<br/>      "uid": 1000<br/>    },<br/>    "tags": {<br/>      "Purpose": "SharedStorage"<br/>    }<br/>  },<br/>  "web_app": {<br/>    "creation_info": {<br/>      "owner_gid": 1001,<br/>      "owner_uid": 1001,<br/>      "permissions": "755"<br/>    },<br/>    "path": "/web",<br/>    "posix_user": {<br/>      "gid": 1001,<br/>      "secondary_gids": [],<br/>      "uid": 1001<br/>    },<br/>    "tags": {<br/>      "Application": "WebApp"<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_create_mount_target_security_group"></a> [create\_mount\_target\_security\_group](#input\_create\_mount\_target\_security\_group) | Create security group for mount targets | `bool` | `true` | no |
| <a name="input_enable_backup_policy"></a> [enable\_backup\_policy](#input\_enable\_backup\_policy) | Whether to enable EFS backup policy | `bool` | `true` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Whether to encrypt the EFS file system | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier (e.g., dev, staging, prod) | `string` | `"poc"` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | EFS lifecycle policy | <pre>object({<br/>    transition_to_ia                    = string<br/>    transition_to_primary_storage_class = string<br/>  })</pre> | <pre>{<br/>  "transition_to_ia": "AFTER_30_DAYS",<br/>  "transition_to_primary_storage_class": "AFTER_1_ACCESS"<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EFS file system | `string` | `"access-points-example"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources | `string` | `"arc"` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | EFS performance mode | `string` | `"generalPurpose"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "prod",<br/>  "Example": "AccessPoints",<br/>  "Namespace": "arc",<br/>  "Project": "ARC"<br/>}</pre> | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | EFS throughput mode | `string` | `"elastic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_point_ids"></a> [access\_point\_ids](#output\_access\_point\_ids) | List of access point IDs |
| <a name="output_access_points"></a> [access\_points](#output\_access\_points) | Access points created |
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | DNS name of the EFS file system |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | ID of the EFS file system |
| <a name="output_mount_targets"></a> [mount\_targets](#output\_mount\_targets) | Mount targets information |
<!-- END_TF_DOCS -->

### Mounting Access Points

Each access point can be mounted independently:

#### Web Application Mount
```bash
# Create mount point
sudo mkdir -p /mnt/web-app

# Mount using access point
sudo mount -t efs -o tls,accesspoint=<web-ap-id> <efs-id>:/ /mnt/web-app

# Verify access
ls -la /mnt/web-app
# Should show ownership as 1001:1001
```

#### Database Backup Mount
```bash
# Create mount point
sudo mkdir -p /mnt/db-backup

# Mount using access point
sudo mount -t efs -o tls,accesspoint=<db-ap-id> <efs-id>:/ /mnt/db-backup

# Verify restricted access
ls -la /mnt/db-backup
# Should show ownership as 1002:1002 with 750 permissions
```

#### Shared Storage Mount
```bash
# Create mount point
sudo mkdir -p /mnt/shared

# Mount using access point
sudo mount -t efs -o tls,accesspoint=<shared-ap-id> <efs-id>:/ /mnt/shared

# Verify shared access
ls -la /mnt/shared
# Should show 777 permissions
```

### Permanent Mounting

Add to `/etc/fstab`:
```bash
# Web application mount
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/web-app efs defaults,_netdev,tls,accesspoint=<web-ap-id> 0 0

# Database backup mount
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/db-backup efs defaults,_netdev,tls,accesspoint=<db-ap-id> 0 0

# Shared storage mount
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/shared efs defaults,_netdev,tls,accesspoint=<shared-ap-id> 0 0
```

## Configuration Details

### EFS Settings
- **Performance Mode**: `generalPurpose` (up to 7,000 operations/sec)
- **Throughput Mode**: `elastic` (automatic scaling)
- **Encryption**: Enabled with AWS managed key
- **Backup**: Automatic backup policy enabled

### Access Points Configuration

| Access Point | Path | UID:GID | Permissions | Use Case |
|-------------|------|---------|-------------|----------|
| web_app | `/web` | 1001:1001 | 755 | Web applications |
| db_backup | `/database/backups` | 1002:1002 | 750 | Database backups |
| shared | `/shared` | 1000:1000 | 777 | Shared storage |

### Lifecycle Policy
- **Transition to IA**: After 30 days of inactivity
- **Return to Standard**: After 1 access to IA files
- **Cost Savings**: Up to 85% for infrequently accessed files

## Security Benefits

### Application Isolation
- Each application accesses only its designated directory
- POSIX permissions enforced at the NFS level
- No risk of accidental cross-application file access

### User/Group Enforcement
- Access points map NFS clients to specific user/group IDs
- Eliminates need to manage users on each client
- Centralized permission management

### Network Security
- Security groups restrict access to authorized CIDR blocks
- Encryption in transit available with TLS mount option
- VPC-level network isolation

## Outputs

| Name | Description |
|------|-------------|
| `efs_id` | EFS file system ID |
| `efs_dns_name` | DNS name for mounting |
| `access_points` | Map of all access points with IDs and ARNs |
| `access_point_ids` | List of access point IDs |
| `mount_targets` | Information about mount targets |

## Customization

### Adding New Access Point
Add to the access_points map in `main.tf`:
```hcl
logs = {
  path = "/logs"
  creation_info = {
    owner_gid   = 1003
    owner_uid   = 1003
    permissions = "755"
  }
  posix_user = {
    gid = 1003
    uid = 1003
  }
  tags = {
    Application = "Logging"
    Purpose     = "Log Storage"
  }
}
```

### Modifying Permissions
Change the permissions in the creation_info block:
- `755`: Owner read/write/execute, group/others read/execute
- `750`: Owner read/write/execute, group read/execute, others no access
- `700`: Owner read/write/execute only
- `777`: Full access for all (use with caution)

### Secondary Groups
Add secondary groups to posix_user:
```hcl
posix_user = {
  gid            = 1001
  uid            = 1001
  secondary_gids = [1010, 1011, 1020]
}
```

## Troubleshooting

### Common Issues

1. **Permission Denied**
   - Check that the client process runs as the correct user ID
   - Verify access point POSIX user configuration
   - Ensure directory permissions allow access

2. **Access Point Mount Fails**
   - Verify access point ID is correct
   - Check security group rules allow NFS traffic
   - Ensure EFS mount helper is installed

3. **Wrong User/Group Ownership**
   - Access points override client user IDs
   - Check posix_user configuration in access point
   - Verify creation_info sets correct ownership

### Useful Commands

```bash
# List access points for EFS
aws efs describe-access-points --file-system-id <efs-id>

# Check access point details
aws efs describe-access-points --access-point-id <ap-id>

# Test NFS connectivity
showmount -e <efs-dns-name>

# Check mount status
mount | grep efs
```

## Performance Considerations

### Elastic Throughput
- Automatically scales throughput based on workload
- No performance impact during scaling
- Optimal for variable workloads

### Access Point Performance
- No performance penalty for using access points
- Each access point has the same performance characteristics
- Multiple access points can be used simultaneously

## Cost Optimization

### Lifecycle Policy Benefits
- **Standard Storage**: $0.30/GB-month
- **Standard-IA**: $0.045/GB-month (85% savings)
- **Automatic Tiering**: Based on access patterns
- **Retrieval Fee**: $0.01/GB for IA access

### Elastic Throughput Pricing
- Pay for actual throughput used
- No provisioning required
- Automatic cost optimization

## Next Steps

- Explore [replication example](../with-replication/) for disaster recovery
- Check [complete example](../complete/) for enterprise features
- Review [basic example](../basic/) for simpler setups

## Cleanup

To remove all resources:
```bash
terraform destroy
```

**Note**: Ensure all data is backed up before destroying the EFS file system.
