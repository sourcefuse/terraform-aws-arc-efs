# Basic EFS Example

This example demonstrates a simple AWS EFS setup suitable for development environments or straightforward storage needs.

## Overview

This example creates:
- A basic EFS file system with general-purpose performance mode
- Mount targets in multiple availability zones
- A security group allowing NFS access from specified CIDR blocks
- Backup policy enabled for data protection



## Features

- **Basic Configuration**: Simple EFS setup with default settings
- **Multi-AZ**: Mount targets in multiple availability zones
- **Security**: Dedicated security group with NFS access rules
- **Encryption**: Encryption at rest enabled by default
- **Backup**: Automatic backup policy enabled
- **Cost-Effective**: Uses bursting throughput mode for variable workloads

## Usage

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5 installed
- Default VPC with at least 2 subnets in different AZs

### Quick Start

1. **Clone and Navigate**
   ```bash
   git clone <repository-url>
   cd examples/basic
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
   environment = "dev"
   name        = "shared-storage"

   # Optional: Override default tags
   additional_tags = {
     Owner       = "DevOps Team"
     Application = "Shared Storage"
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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs"></a> [efs](#module\_efs) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | CIDR blocks allowed to access EFS | `list(string)` | <pre>[<br/>  "10.12.0.0/16"<br/>]</pre> | no |
| <a name="input_create_mount_target_security_group"></a> [create\_mount\_target\_security\_group](#input\_create\_mount\_target\_security\_group) | Create security group for mount targets | `bool` | `true` | no |
| <a name="input_enable_backup_policy"></a> [enable\_backup\_policy](#input\_enable\_backup\_policy) | Whether to enable EFS backup policy | `bool` | `true` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Whether to encrypt the EFS file system | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| <a name="input_mount_target_security_group_vpc_id"></a> [mount\_target\_security\_group\_vpc\_id](#input\_mount\_target\_security\_group\_vpc\_id) | VPC ID for the security group | `string` | `"vpc-0e6c09980580ecbf6"` | no |
| <a name="input_mount_targets"></a> [mount\_targets](#input\_mount\_targets) | Mount targets configuration | <pre>map(object({<br/>    subnet_id = string<br/>  }))</pre> | <pre>{<br/>  "us-east-1a": {<br/>    "subnet_id": "subnet-066d0c78479b72e77"<br/>  },<br/>  "us-east-1b": {<br/>    "subnet_id": "subnet-0c55ffb1f4a8bd7c2"<br/>  }<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EFS file system | `string` | `"basic-example"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources | `string` | `"arc"` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | EFS performance mode | `string` | `"generalPurpose"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "dev",<br/>  "Example": "Basic",<br/>  "Namespace": "arc",<br/>  "Project": "ARC"<br/>}</pre> | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | EFS throughput mode | `string` | `"bursting"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | DNS name of the EFS file system |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | ID of the EFS file system |
| <a name="output_mount_targets"></a> [mount\_targets](#output\_mount\_targets) | Mount targets information |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID for mount targets |
<!-- END_TF_DOCS -->

### Connecting to EFS

After deployment, connect to your EFS file system:

1. **Install EFS utilities** (Amazon Linux 2):
   ```bash
   sudo yum install -y amazon-efs-utils
   ```

2. **Create mount point**:
   ```bash
   sudo mkdir /mnt/efs
   ```

3. **Mount using DNS name**:
   ```bash
   sudo mount -t efs <efs-dns-name>:/ /mnt/efs
   ```

4. **Or mount using mount helper**:
   ```bash
   sudo mount -t efs -o tls <efs-id>:/ /mnt/efs
   ```

### Permanent Mount

Add to `/etc/fstab` for permanent mounting:
```bash
echo "<efs-dns-name>:/ /mnt/efs efs defaults,_netdev" | sudo tee -a /etc/fstab
```

## Configuration Details

### EFS Settings
- **Performance Mode**: `generalPurpose` (up to 7,000 operations/sec)
- **Throughput Mode**: `bursting` (scales with file system size)
- **Encryption**: Enabled with default AWS managed key
- **Backup**: Automatic backup policy enabled

### Security
- **Security Group**: Allows NFS (port 2049) from VPC CIDR
- **Network**: Uses default VPC and subnets
- **Access**: No access points (root access via mount targets)

### Cost Optimization
- Uses bursting throughput mode (no additional charges for throughput)
- No lifecycle policy configured (all data remains in Standard storage)


## Customization

### Adding More Availability Zones
Modify the mount targets configuration in `main.tf`:
```hcl
mount_targets = {
  "us-east-1a" = { subnet_id = data.aws_subnets.default.ids[0] }
  "us-east-1b" = { subnet_id = data.aws_subnets.default.ids[1] }
  "us-east-1c" = { subnet_id = data.aws_subnets.default.ids[2] }
}
```

### Using Different VPC
Replace the data sources with your VPC information:
```hcl
data "aws_vpc" "custom" {
  id = "vpc-your-vpc-id"
}

data "aws_subnets" "custom" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.custom.id]
  }
}
```

### Adding Lifecycle Policy
Add cost optimization with lifecycle management:
```hcl
lifecycle_policy = {
  transition_to_ia = "AFTER_30_DAYS"
}
```

## Cleanup

To remove all resources:
```bash
terraform destroy
```

## Security Considerations

- EFS is accessible from any resource in the specified CIDR blocks
- Consider using more restrictive CIDR blocks in production
- For enhanced security, consider using access points (see other examples)
- Enable VPC Flow Logs to monitor network traffic

## Troubleshooting

### Common Issues

1. **Mount fails**: Check security group rules and network connectivity
2. **Permission denied**: Ensure proper IAM permissions for EFS
3. **Slow performance**: Consider using provisioned throughput mode

### Useful Commands

```bash
# Check mount status
df -h /mnt/efs

# Monitor EFS performance
aws efs describe-file-systems --file-system-id <efs-id>

# View security group rules
aws ec2 describe-security-groups --group-ids <sg-id>
```

## Next Steps

- Explore [access points example](../with-access-points/) for multi-tenant setups
- Check [replication example](../with-replication/) for disaster recovery
- Review [complete example](../complete/) for enterprise features

## Cost Estimate

This basic setup typically costs:
- **Storage**: $0.30/GB-month (Standard storage class)
- **Throughput**: Included with bursting mode
- **Backup**: $0.05/GB-month for backup storage

*Prices may vary by region. Check current AWS pricing for accurate estimates.*
