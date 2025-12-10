# EFS with Cross-Region Replication Example

This example demonstrates how to create a production-ready EFS file system with cross-region replication for disaster recovery, high-performance configuration, and advanced security features.

## Overview

This example creates:
- An EFS file system optimized for high-performance workloads
- Cross-region replication for business continuity and disaster recovery
- High-performance configuration with maxIO performance mode and provisioned throughput
- Lifecycle policy for cost optimization
- Advanced security group rules for granular access control
- Mount targets across multiple availability zones

## Features

- **High Performance**: Max I/O mode with provisioned throughput (500 MiB/s)
- **Disaster Recovery**: Automatic cross-region replication to us-west-2
- **Cost Optimization**: Lifecycle policy moves files to IA after 7 days
- **Enhanced Security**: Advanced security group rules
- **Production Ready**: Optimized for enterprise workloads
- **Compliance**: Meets most regulatory requirements for data protection

## Use Cases

### High-Performance Workloads
- **Media Processing**: Video encoding, image processing
- **Big Data Analytics**: Large dataset processing
- **Database Storage**: High-throughput database files
- **Content Distribution**: High-traffic web content

### Disaster Recovery
- **Business Continuity**: Automatic failover capability
- **Compliance**: Meet regulatory backup requirements
- **Data Protection**: Geographic redundancy
- **RTO/RPO**: Minimal recovery time and data loss objectives

## Performance Specifications

| Metric | Value | Description |
|--------|-------|-------------|
| Performance Mode | maxIO | Up to higher aggregate throughput and operations per second |
| Throughput Mode | Provisioned | 500 MiB/s guaranteed throughput |
| Latency | Slightly Higher | Trade-off for higher throughput capabilities |
| Concurrent Connections | High | Supports many simultaneous clients |

## Usage

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5 installed
- Permissions for EFS replication in both regions
- KMS key permissions (if using custom encryption)

### Quick Start

1. **Clone and Navigate**
   ```bash
   git clone <repository-url>
   cd examples/with-replication
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
   name        = "disaster-recovery-efs"

   # Performance configuration
   provisioned_throughput_mibps = 1000

   # Replication configuration
   replication_region = "us-west-1"

   # Lifecycle configuration
   transition_to_ia_days = "AFTER_14_DAYS"

   additional_tags = {
     Owner = "Infrastructure Team"
     Criticality = "High"
     Backup = "Required"
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
| <a name="input_additional_security_group_rules"></a> [additional\_security\_group\_rules](#input\_additional\_security\_group\_rules) | Additional security group rules | <pre>map(object({<br/>    type        = string<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>    description = string<br/>  }))</pre> | <pre>{<br/>  "management_access": {<br/>    "cidr_blocks": [<br/>      "10.0.100.0/24"<br/>    ],<br/>    "description": "NFS access from management subnet",<br/>    "from_port": 2049,<br/>    "protocol": "tcp",<br/>    "to_port": 2049,<br/>    "type": "ingress"<br/>  }<br/>}</pre> | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | CIDR blocks allowed to access EFS | `list(string)` | <pre>[<br/>  "10.12.0.0/16"<br/>]</pre> | no |
| <a name="input_allowed_security_group_ids"></a> [allowed\_security\_group\_ids](#input\_allowed\_security\_group\_ids) | Security group IDs allowed to access EFS | `list(string)` | `[]` | no |
| <a name="input_create_mount_target_security_group"></a> [create\_mount\_target\_security\_group](#input\_create\_mount\_target\_security\_group) | Create security group for mount targets | `bool` | `true` | no |
| <a name="input_enable_backup_policy"></a> [enable\_backup\_policy](#input\_enable\_backup\_policy) | Whether to enable EFS backup policy | `bool` | `true` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Whether to encrypt the EFS file system | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier (e.g., dev, staging, prod) | `string` | `"prod"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for encryption | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | EFS lifecycle policy | <pre>object({<br/>    transition_to_ia = string<br/>  })</pre> | <pre>{<br/>  "transition_to_ia": "AFTER_7_DAYS"<br/>}</pre> | no |
| <a name="input_mount_target_security_group_vpc_id"></a> [mount\_target\_security\_group\_vpc\_id](#input\_mount\_target\_security\_group\_vpc\_id) | VPC ID for the security group | `string` | `"vpc-0e6c09980580ecbf6"` | no |
| <a name="input_mount_targets"></a> [mount\_targets](#input\_mount\_targets) | Mount targets configuration | <pre>map(object({<br/>    subnet_id = string<br/>  }))</pre> | <pre>{<br/>  "us-east-1a": {<br/>    "subnet_id": "subnet-066d0c78479b72e77"<br/>  },<br/>  "us-east-1b": {<br/>    "subnet_id": "subnet-0c55ffb1f4a8bd7c2"<br/>  }<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EFS file system | `string` | `"replication-example"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources | `string` | `"arc"` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | EFS performance mode | `string` | `"maxIO"` | no |
| <a name="input_provisioned_throughput_mibps"></a> [provisioned\_throughput\_mibps](#input\_provisioned\_throughput\_mibps) | Provisioned throughput in MiBps | `number` | `500` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Cross-region replication configuration | <pre>object({<br/>    destination = object({<br/>      region     = string<br/>      kms_key_id = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "destination": {<br/>    "kms_key_id": null,<br/>    "region": "us-east-2"<br/>  }<br/>}</pre> | no |
| <a name="input_replication_region"></a> [replication\_region](#input\_replication\_region) | aws region for replication | `string` | `"us-east-2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br/>  "BackupStrategy": "CrossRegion",<br/>  "Compliance": "Required",<br/>  "Environment": "prod",<br/>  "Example": "Replication",<br/>  "Namespace": "arc",<br/>  "Project": "ARC"<br/>}</pre> | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | EFS throughput mode | `string` | `"provisioned"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_arn"></a> [efs\_arn](#output\_efs\_arn) | ARN of the EFS file system |
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | DNS name of the EFS file system |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | ID of the EFS file system |
| <a name="output_mount_targets"></a> [mount\_targets](#output\_mount\_targets) | Mount targets information |
| <a name="output_replication_configuration_id"></a> [replication\_configuration\_id](#output\_replication\_configuration\_id) | ID of the replication configuration |
| <a name="output_replication_destination_file_system_id"></a> [replication\_destination\_file\_system\_id](#output\_replication\_destination\_file\_system\_id) | The file system ID of the replica |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID for mount targets |
<!-- END_TF_DOCS -->

### Mounting the File System

#### High-Performance Mount
```bash
# Create mount point
sudo mkdir -p /mnt/high-perf-efs

# Mount with performance optimizations
sudo mount -t efs -o tls,fsc,_netdev <efs-id>:/ /mnt/high-perf-efs

# Verify mount
df -h /mnt/high-perf-efs
```

#### Production Mount with Options
```bash
# Mount with production settings
sudo mount -t efs -o tls,_netdev,fsc,regional,rsize=1048576,wsize=1048576 \
  <efs-id>:/ /mnt/high-perf-efs
```

### Permanent Mount Configuration

Add to `/etc/fstab` with performance optimizations:
```bash
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/high-perf-efs efs defaults,_netdev,tls,fsc,regional,rsize=1048576,wsize=1048576 0 0
```

## Configuration Details

### EFS Settings
- **Performance Mode**: `maxIO` (higher aggregate throughput)
- **Throughput Mode**: `provisioned` (500 MiB/s)
- **Encryption**: Enabled with AWS managed key
- **Backup**: Automatic backup policy enabled

### Replication Configuration
- **Source Region**: us-east-1 (primary)
- **Destination Region**: us-west-2 (replica)
- **Replication Type**: Automatic, continuous
- **Replica Access**: Read-only (for disaster recovery)

### Lifecycle Policy
- **Transition to IA**: After 7 days (faster cost optimization)
- **Cost Savings**: Up to 85% for infrequently accessed files
- **Retrieval**: Automatic transition back to Standard on access

### Security Features
- **Network Isolation**: VPC-only access
- **Encryption**: At rest and in transit capabilities
- **Access Control**: Security group-based restrictions
- **Audit Trail**: CloudTrail logging for all API calls

## Disaster Recovery Procedures

### Failover to Replica Region

1. **Verify Replica Status**
   ```bash
   aws efs describe-replication-configurations \
     --source-file-system-id <primary-efs-id> \
     --region us-east-1
   ```

2. **Create Mount Targets in Replica Region**
   ```bash
   # Switch to replica region
   export AWS_DEFAULT_REGION=us-west-2

   # Get replica file system ID
   REPLICA_EFS_ID=$(aws efs describe-replication-configurations \
     --source-file-system-id <primary-efs-id> \
     --region us-east-1 \
     --query 'ReplicationConfigurations[0].Destinations[0].FileSystemId' \
     --output text)

   # Create mount targets in replica region (manual process)
   ```

3. **Update Application Configuration**
   ```bash
   # Update applications to use replica EFS ID
   # Update DNS records to point to us-west-2
   # Update security groups in replica region
   ```

### Failback Procedures

1. **Verify Primary Region Recovery**
2. **Stop replication** (if needed)
3. **Sync any changes** from replica back to primary
4. **Re-establish replication** in the correct direction
5. **Update applications** to use primary region

## Performance Optimization

### Mount Options for Maximum Performance
```bash
# Optimized mount command
sudo mount -t efs -o tls,fsc,regional,rsize=1048576,wsize=1048576,hard,intr \
  <efs-id>:/ /mnt/efs
```

### Client-Side Caching
```bash
# Enable EFS Intelligent Tiering client cache
sudo mount -t efs -o tls,fsc <efs-id>:/ /mnt/efs
```

### Kernel Parameters
```bash
# Optimize network settings
echo 'net.core.rmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
echo 'net.core.wmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.conf
sysctl -p
```

## Monitoring and Alerting

### CloudWatch Metrics to Monitor
```bash
# Primary metrics
- TotalIOBytes
- DataReadIOBytes
- DataWriteIOBytes
- ThroughputUtilization
- PercentIOLimit

# Replication metrics
- ReplicationThroughput
- ReplicationLag
```

### Recommended Alarms
```bash
# High throughput utilization
aws cloudwatch put-metric-alarm \
  --alarm-name "EFS-High-Throughput-Utilization" \
  --alarm-description "EFS throughput utilization > 80%" \
  --metric-name ThroughputUtilization \
  --namespace AWS/EFS \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold

# Replication lag alert
aws cloudwatch put-metric-alarm \
  --alarm-name "EFS-Replication-Lag" \
  --alarm-description "EFS replication lag > 15 minutes" \
  --metric-name ReplicationLag \
  --namespace AWS/EFS \
  --statistic Average \
  --period 900 \
  --threshold 900 \
  --comparison-operator GreaterThanThreshold
```

## Cost Analysis

### Primary Region Costs (Monthly)
- **Storage**: Variable based on data volume
  - Standard: $0.30/GB-month
  - Standard-IA: $0.045/GB-month (after lifecycle transition)
- **Provisioned Throughput**: $6.00/MiB/s-month × 500 = $3,000/month
- **Backup**: $0.05/GB-month for backup storage

### Replication Costs
- **Replication**: 15% of Standard storage pricing
- **Cross-Region Transfer**: $0.02/GB for data transfer
- **Replica Storage**: Standard pricing in destination region

### Cost Optimization Tips
1. **Monitor Throughput Usage**: Adjust provisioned throughput based on actual needs
2. **Lifecycle Policies**: Aggressive IA transition for cost savings
3. **Regional Considerations**: Choose cost-effective replica regions
4. **Right-sizing**: Monitor and adjust throughput provisioning

## Security Best Practices

### Network Security
```bash
# Restrict access to specific subnets
allowed_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]

# Use VPC endpoints for AWS API calls
# Enable VPC Flow Logs for monitoring
```

### Encryption
```bash
# Enable encryption in transit for all mounts
sudo mount -t efs -o tls <efs-id>:/ /mnt/efs

# Use IAM roles for EC2 instances
# Implement EFS Access Points for application isolation
```

### Access Control
```bash
# Use security groups instead of CIDR blocks where possible
# Implement least privilege principles
# Regular access reviews and audits
```

## Troubleshooting

### Common Issues

1. **High Latency**
   - Check if using maxIO mode appropriately
   - Verify network path between client and EFS
   - Monitor CloudWatch metrics for bottlenecks

2. **Throughput Limitations**
   - Verify provisioned throughput settings
   - Check for burst credit depletion (if mixed mode)
   - Monitor ThroughputUtilization metric

3. **Replication Issues**
   - Verify cross-region permissions
   - Check KMS key access in destination region
   - Monitor replication lag metrics

4. **Mount Failures**
   - Verify security group rules
   - Check EFS mount helper installation
   - Validate DNS resolution

### Useful Commands

```bash
# Monitor replication status
aws efs describe-replication-configurations \
  --source-file-system-id <efs-id>

# Check throughput utilization
aws cloudwatch get-metric-statistics \
  --namespace AWS/EFS \
  --metric-name ThroughputUtilization \
  --dimensions Name=FileSystemId,Value=<efs-id> \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-01T01:00:00Z \
  --period 300 \
  --statistics Average

# Test network performance
iperf3 -c <efs-mount-target-ip> -p 2049 -t 60

# Monitor file system usage
df -h /mnt/efs
du -sh /mnt/efs/*
```

## Outputs

| Name | Description |
|------|-------------|
| `efs_id` | Primary EFS file system ID |
| `efs_arn` | Primary EFS file system ARN |
| `efs_dns_name` | DNS name for mounting |
| `replication_configuration_id` | Replication configuration ID |
| `replication_destination_file_system_id` | Replica file system ID |
| `mount_targets` | Mount target information |
| `security_group_id` | Security group ID |

## Next Steps

- Explore [complete example](../complete/) for enterprise features
- Review [access points example](../with-access-points/) for multi-tenancy
- Check [basic example](../basic/) for simpler setups

## Cleanup

```bash
# Stop replication first (if desired)
aws efs delete-replication-configuration \
  --source-file-system-id <efs-id>

# Then destroy Terraform resources
terraform destroy
```

**Warning**: Ensure all critical data is backed up before destroying resources. The replica file system will also be deleted when replication is removed.
