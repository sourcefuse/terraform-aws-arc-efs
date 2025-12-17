# Complete EFS Example - Enterprise Grade

This example demonstrates a comprehensive, enterprise-grade AWS EFS deployment with all available features, security best practices, and production-ready configurations suitable for mission-critical workloads.

## Overview

This is the most comprehensive example that showcases:
- **Custom KMS encryption** with dedicated encryption keys
- **Multiple access points** for different applications and use cases
- **High-performance configuration** with maxIO and provisioned throughput
- **Cross-region replication** for disaster recovery
- **Advanced security controls** with file system policies and security groups
- **Cost optimization** with intelligent lifecycle management
- **Comprehensive monitoring** setup with detailed tagging

## Features

- **Enterprise Security**: Custom KMS encryption, file system policies, advanced RBAC
- **High Performance**: MaxIO mode with 1000 MiB/s provisioned throughput
- **Multi-Application Support**: 4 dedicated access points with specific permissions
- **Disaster Recovery**: Cross-region replication with custom encryption
- **Cost Optimization**: Intelligent tiering (30 days → IA, 1 access → Standard)
- **Compliance Ready**: SOC2 compatible with comprehensive audit trails
- **Production Hardened**: Advanced security groups and network controls
- **Monitoring Ready**: Comprehensive tagging for CloudWatch and cost allocation

## Use Cases

### Enterprise Applications
- **ERP Systems**: High-performance shared storage for enterprise applications
- **Content Management**: Multi-tenant content storage with isolation
- **Data Analytics**: Shared datasets for analytics and ML workloads
- **Development Platforms**: Shared development environments and CI/CD pipelines

### Compliance Scenarios
- **Financial Services**: SOC2, PCI DSS compliant storage
- **Healthcare**: HIPAA compliant with encryption and access controls
- **Government**: FedRAMP ready with advanced security features
- **Legal**: Document storage with retention and audit requirements

## Access Points Configuration

| Access Point | Path | UID:GID | Permissions | Use Case | Secondary GIDs |
|-------------|------|---------|-------------|----------|---------------|
| app_data | `/app/data` | 1001:1001 | 755 | Application files | 1010,1011 |
| database | `/database` | 999:999 | 750 | Database files | - |
| logs | `/logs` | 1002:1002 | 755 | Application logs | - |
| backup | `/backup` | 1003:1003 | 700 | Backup storage | - |

## Performance Specifications

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **Performance Mode** | maxIO | Maximum aggregate throughput and IOPS |
| **Throughput Mode** | Provisioned (1000 MiB/s) | Guaranteed high-performance |
| **Storage Classes** | Standard + IA | Cost optimization with lifecycle |
| **Encryption** | Custom KMS Key | Enterprise-grade encryption |
| **Replication** | Cross-region | Business continuity |

## Usage

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5 installed
- KMS key creation permissions
- Cross-region permissions for replication
- VPC with multiple subnets across AZs

### Quick Start

1. **Clone and Navigate**
   ```bash
   git clone <repository-url>
   cd examples/complete
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Customize Variables** (Optional)
   ```bash
   # Create terraform.tfvars file
   cat > terraform.tfvars <<EOF
   namespace   = "enterprise"
   environment = "prod"
   name        = "mission-critical-efs"

   # High-performance configuration
   provisioned_throughput_mibps = 2000

   # Custom KMS key configuration
   kms_key_description = "Enterprise EFS encryption key"
   kms_key_deletion_window = 30

   # Replication settings
   replication_region = "eu-west-1"

   # Access point customization
   app_data_uid = 2001
   app_data_gid = 2001

   database_uid = 1999
   database_gid = 1999

   # Advanced tags
   additional_tags = {
     Owner           = "Platform Engineering"
     CostCenter      = "Infrastructure"
     Compliance      = "SOC2-PCI"
     DataClass       = "Confidential"
     BusinessUnit    = "Engineering"
     BackupRetention = "7Years"
   }
   EOF
   ```

4. **Plan and Apply**
   ```bash
   terraform plan
   terraform apply
   ```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.26.0 |

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
| <a name="input_access_points"></a> [access\_points](#input\_access\_points) | EFS access points configuration | <pre>map(object({<br/>    path = string<br/>    creation_info = object({<br/>      owner_gid   = number<br/>      owner_uid   = number<br/>      permissions = string<br/>    })<br/>    posix_user = object({<br/>      gid            = number<br/>      uid            = number<br/>      secondary_gids = list(number)<br/>    })<br/>    tags = map(string)<br/>  }))</pre> | <pre>{<br/>  "app_data": {<br/>    "creation_info": {<br/>      "owner_gid": 1001,<br/>      "owner_uid": 1001,<br/>      "permissions": "755"<br/>    },<br/>    "path": "/app/data",<br/>    "posix_user": {<br/>      "gid": 1001,<br/>      "secondary_gids": [<br/>        1010,<br/>        1011<br/>      ],<br/>      "uid": 1001<br/>    },<br/>    "tags": {<br/>      "Application": "WebApp",<br/>      "DataType": "ApplicationData"<br/>    }<br/>  },<br/>  "backup": {<br/>    "creation_info": {<br/>      "owner_gid": 1003,<br/>      "owner_uid": 1003,<br/>      "permissions": "700"<br/>    },<br/>    "path": "/backup",<br/>    "posix_user": {<br/>      "gid": 1003,<br/>      "secondary_gids": [],<br/>      "uid": 1003<br/>    },<br/>    "tags": {<br/>      "DataType": "BackupData",<br/>      "Purpose": "Backup",<br/>      "Retention": "LongTerm"<br/>    }<br/>  },<br/>  "database": {<br/>    "creation_info": {<br/>      "owner_gid": 999,<br/>      "owner_uid": 999,<br/>      "permissions": "750"<br/>    },<br/>    "path": "/database",<br/>    "posix_user": {<br/>      "gid": 999,<br/>      "secondary_gids": [],<br/>      "uid": 999<br/>    },<br/>    "tags": {<br/>      "Application": "Database",<br/>      "DataType": "DatabaseFiles"<br/>    }<br/>  },<br/>  "logs": {<br/>    "creation_info": {<br/>      "owner_gid": 1002,<br/>      "owner_uid": 1002,<br/>      "permissions": "755"<br/>    },<br/>    "path": "/logs",<br/>    "posix_user": {<br/>      "gid": 1002,<br/>      "secondary_gids": [],<br/>      "uid": 1002<br/>    },<br/>    "tags": {<br/>      "DataType": "ApplicationLogs",<br/>      "Purpose": "LogStorage"<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_additional_security_group_rules"></a> [additional\_security\_group\_rules](#input\_additional\_security\_group\_rules) | Additional security group rules | <pre>map(object({<br/>    type        = string<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>    description = string<br/>  }))</pre> | <pre>{<br/>  "health_check_egress": {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "HTTPS egress for health checks",<br/>    "from_port": 443,<br/>    "protocol": "tcp",<br/>    "to_port": 443,<br/>    "type": "egress"<br/>  },<br/>  "management_access": {<br/>    "cidr_blocks": [<br/>      "10.0.100.0/24"<br/>    ],<br/>    "description": "NFS access from management subnet",<br/>    "from_port": 2049,<br/>    "protocol": "tcp",<br/>    "to_port": 2049,<br/>    "type": "ingress"<br/>  }<br/>}</pre> | no |
| <a name="input_allowed_security_group_ids"></a> [allowed\_security\_group\_ids](#input\_allowed\_security\_group\_ids) | Security group IDs allowed to access EFS | `list(string)` | `[]` | no |
| <a name="input_bypass_policy_lockout_safety_check"></a> [bypass\_policy\_lockout\_safety\_check](#input\_bypass\_policy\_lockout\_safety\_check) | Bypass policy lockout safety check | `bool` | `false` | no |
| <a name="input_create_mount_target_security_group"></a> [create\_mount\_target\_security\_group](#input\_create\_mount\_target\_security\_group) | Create security group for mount targets | `bool` | `true` | no |
| <a name="input_creation_token"></a> [creation\_token](#input\_creation\_token) | Unique token for EFS creation | `string` | `"arc-prod-complete-example-token"` | no |
| <a name="input_enable_backup_policy"></a> [enable\_backup\_policy](#input\_enable\_backup\_policy) | Enable EFS backup policy | `bool` | `true` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Enable EFS encryption | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier (e.g., dev, staging, prod) | `string` | `"poc"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for encryption (will be created by separate KMS module) | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | EFS lifecycle policy | <pre>object({<br/>    transition_to_ia                    = string<br/>    transition_to_primary_storage_class = string<br/>  })</pre> | <pre>{<br/>  "transition_to_ia": "AFTER_30_DAYS",<br/>  "transition_to_primary_storage_class": "AFTER_1_ACCESS"<br/>}</pre> | no |
| <a name="input_mount_target_security_group_description"></a> [mount\_target\_security\_group\_description](#input\_mount\_target\_security\_group\_description) | Description for the mount target security group | `string` | `"Security group for EFS mount targets - Complete Example"` | no |
| <a name="input_mount_target_security_group_name"></a> [mount\_target\_security\_group\_name](#input\_mount\_target\_security\_group\_name) | Name for the mount target security group | `string` | `"arc-prod-complete-example-efs-sg"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EFS file system | `string` | `"complete-example"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources | `string` | `"arc"` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | EFS performance mode | `string` | `"maxIO"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | EFS file system policy JSON | `string` | `"{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"elasticfilesystem:ClientMount\",\"elasticfilesystem:ClientWrite\",\"elasticfilesystem:ClientRootAccess\"],\"Resource\":\"*\",\"Condition\":{\"Bool\":{\"aws:SecureTransport\":\"true\"}}}]}"` | no |
| <a name="input_provisioned_throughput_mibps"></a> [provisioned\_throughput\_mibps](#input\_provisioned\_throughput\_mibps) | Provisioned throughput in MiBps | `number` | `1000` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Cross-region replication configuration | <pre>object({<br/>    destination = object({<br/>      region     = string<br/>      kms_key_id = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "destination": {<br/>    "kms_key_id": null,<br/>    "region": "us-east-2"<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br/>  "BackupStrategy": "CrossRegion",<br/>  "Compliance": "SOC2",<br/>  "CostOptimized": "true",<br/>  "DataClass": "Sensitive",<br/>  "Environment": "prod",<br/>  "Example": "Complete",<br/>  "MonitoringLevel": "Enhanced",<br/>  "Namespace": "arc",<br/>  "Project": "ARC"<br/>}</pre> | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | EFS throughput mode | `string` | `"provisioned"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_point_arns"></a> [access\_point\_arns](#output\_access\_point\_arns) | List of access point ARNs |
| <a name="output_access_point_ids"></a> [access\_point\_ids](#output\_access\_point\_ids) | List of access point IDs |
| <a name="output_access_points"></a> [access\_points](#output\_access\_points) | Access points created |
| <a name="output_backup_policy_id"></a> [backup\_policy\_id](#output\_backup\_policy\_id) | ID of the backup policy |
| <a name="output_complete_efs_config"></a> [complete\_efs\_config](#output\_complete\_efs\_config) | Complete EFS configuration for reference |
| <a name="output_efs_arn"></a> [efs\_arn](#output\_efs\_arn) | ARN of the EFS file system |
| <a name="output_efs_creation_token"></a> [efs\_creation\_token](#output\_efs\_creation\_token) | Creation token of the EFS file system |
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | DNS name of the EFS file system |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | ID of the EFS file system |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of the KMS key used for EFS encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | ID of the KMS key used for EFS encryption |
| <a name="output_mount_target_dns_names"></a> [mount\_target\_dns\_names](#output\_mount\_target\_dns\_names) | DNS names for mount targets |
| <a name="output_mount_targets"></a> [mount\_targets](#output\_mount\_targets) | Mount targets information |
| <a name="output_replication_configuration_id"></a> [replication\_configuration\_id](#output\_replication\_configuration\_id) | ID of the replication configuration |
| <a name="output_replication_destination_file_system_id"></a> [replication\_destination\_file\_system\_id](#output\_replication\_destination\_file\_system\_id) | The file system ID of the replica |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | Security group ARN for mount targets |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security group ID for mount targets |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Advanced Mounting Examples

#### Application Data Mount
```bash
# High-performance mount for applications
sudo mkdir -p /mnt/app-data
sudo mount -t efs -o tls,fsc,regional,accesspoint=<app-ap-id>,rsize=1048576,wsize=1048576 \
  <efs-id>:/ /mnt/app-data

# Verify permissions
ls -la /mnt/app-data
# drwxr-xr-x root root (enforced as 1001:1001 by access point)
```

#### Database Mount
```bash
# Secure database mount
sudo mkdir -p /mnt/database
sudo mount -t efs -o tls,accesspoint=<db-ap-id>,rsize=1048576,wsize=1048576 \
  <efs-id>:/ /mnt/database

# Verify restricted access
ls -la /mnt/database
# drwxr-x--- root root (enforced as 999:999 by access point)
```

#### Backup Storage Mount
```bash
# Highly secure backup mount
sudo mkdir -p /mnt/backup
sudo mount -t efs -o tls,accesspoint=<backup-ap-id> <efs-id>:/ /mnt/backup

# Verify exclusive access
ls -la /mnt/backup
# drwx------ root root (enforced as 1003:1003 by access point)
```

### Production /etc/fstab Configuration

```bash
# Add to /etc/fstab for production systems
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/app-data efs defaults,_netdev,tls,fsc,regional,accesspoint=<app-ap-id>,rsize=1048576,wsize=1048576 0 0
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/database efs defaults,_netdev,tls,accesspoint=<db-ap-id>,rsize=1048576,wsize=1048576 0 0
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/logs efs defaults,_netdev,tls,accesspoint=<logs-ap-id> 0 0
<efs-id>.efs.<region>.amazonaws.com:/ /mnt/backup efs defaults,_netdev,tls,accesspoint=<backup-ap-id> 0 0
```

## Security Configuration

### File System Policy
The example includes a comprehensive file system policy that:
- **Enforces TLS encryption** for all connections
- **Denies unencrypted access** to maintain security posture
- **Allows standard EFS operations** (mount, read, write, root access)
- **Provides audit trail** for all access attempts

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "*"},
      "Action": [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    }
  ]
}
```

### Security Group Rules
- **NFS Access (2049)**: Restricted to VPC CIDR blocks
- **Management Access**: Dedicated subnet for administrative access
- **Application Access**: Security group-based access for applications
- **Health Check Egress**: HTTPS outbound for monitoring

### KMS Encryption
- **Dedicated KMS Key**: Custom key with proper key policy
- **Key Rotation**: Annual automatic rotation enabled
- **Cross-Region**: Replicated with separate KMS key in destination
- **Access Control**: Principle of least privilege for key usage

## Performance Optimization

### Mount Optimizations
```bash
# Maximum performance mount options
sudo mount -t efs -o tls,fsc,regional,rsize=1048576,wsize=1048576,hard,intr,timeo=600,retrans=2 \
  <efs-id>:/ /mnt/efs
```

### Client-Side Caching
```bash
# Enable EFS Intelligent Tiering client cache
echo "<efs-id>.efs.<region>.amazonaws.com:/ /mnt/efs efs defaults,_netdev,tls,fsc" >> /etc/fstab
```

### System Tuning
```bash
# Optimize for high-performance EFS workloads
echo 'net.core.rmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
echo 'net.core.wmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem = 4096 65536 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem = 4096 65536 16777216' >> /etc/sysctl.conf
sysctl -p
```

## Monitoring and Alerting

### CloudWatch Dashboard
```bash
# Create comprehensive EFS dashboard
aws cloudwatch put-dashboard --dashboard-name "EFS-Enterprise-Monitoring" \
  --dashboard-body file://efs-dashboard.json
```

### Critical Alarms
```bash
# Throughput utilization alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "EFS-Critical-Throughput-Utilization" \
  --alarm-description "EFS throughput utilization > 90%" \
  --metric-name ThroughputUtilization \
  --namespace AWS/EFS \
  --statistic Average \
  --period 300 \
  --threshold 90 \
  --comparison-operator GreaterThanThreshold \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:critical-alerts

# Replication lag alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "EFS-Replication-Lag-Critical" \
  --alarm-description "EFS replication lag > 1 hour" \
  --metric-name ReplicationLag \
  --namespace AWS/EFS \
  --statistic Average \
  --period 3600 \
  --threshold 3600 \
  --comparison-operator GreaterThanThreshold

# Burst credit balance alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "EFS-Burst-Credit-Low" \
  --alarm-description "EFS burst credit balance < 20%" \
  --metric-name BurstCreditBalance \
  --namespace AWS/EFS \
  --statistic Average \
  --period 900 \
  --threshold 20 \
  --comparison-operator LessThanThreshold
```

### Custom Metrics
```bash
# Application-level metrics (example)
aws cloudwatch put-metric-data \
  --namespace "EFS/Applications" \
  --metric-data MetricName=ActiveConnections,Value=150,Unit=Count \
  --dimensions FileSystemId=<efs-id>,AccessPoint=app_data
```

## Cost Analysis

### Monthly Cost Breakdown (Estimated)

#### Storage Costs
- **Standard Storage**: $0.30/GB-month
- **Standard-IA**: $0.045/GB-month (85% savings after 30 days)
- **Retrieval Fee**: $0.01/GB from IA storage

#### Performance Costs
- **Provisioned Throughput**: $6.00/MiB/s-month × 1000 = $6,000/month
- **Request Pricing**: Included with provisioned throughput

#### Replication Costs
- **Replication**: 15% of Standard storage pricing
- **Cross-Region Data Transfer**: $0.02/GB
- **Replica Storage**: Standard pricing in destination region

#### Backup Costs
- **Backup Storage**: $0.05/GB-month
- **Backup Restoration**: $0.03/GB

#### Example Monthly Cost (1TB dataset)
```
Storage (1TB):
- First month: $307 (Standard)
- After lifecycle: $61.5 (Standard-IA) + $245 (frequently accessed) = $306.5
Provisioned Throughput: $6,000
Replication: $46 (15% of storage)
Backup: $51 (1TB backup)
Total: ~$6,403/month
```

### Cost Optimization Strategies

1. **Right-size Throughput**: Monitor actual usage and adjust provisioned throughput
2. **Lifecycle Optimization**: Tune IA transition based on access patterns
3. **Regional Strategy**: Choose cost-effective replica regions
4. **Backup Optimization**: Implement tiered backup retention policies

## Disaster Recovery Procedures

### Automated Failover Script
```bash
#!/bin/bash
# DR Failover Script

PRIMARY_REGION="us-east-1"
REPLICA_REGION="us-west-2"
EFS_ID="<primary-efs-id>"

# Check primary region health
if ! aws efs describe-file-systems --file-system-id $EFS_ID --region $PRIMARY_REGION; then
    echo "Primary EFS unreachable, initiating DR procedures..."

    # Get replica EFS ID
    REPLICA_EFS_ID=$(aws efs describe-replication-configurations \
        --source-file-system-id $EFS_ID \
        --region $PRIMARY_REGION \
        --query 'ReplicationConfigurations[0].Destinations[0].FileSystemId' \
        --output text)

    # Update Route 53 to point to replica region
    aws route53 change-resource-record-sets \
        --hosted-zone-id $HOSTED_ZONE_ID \
        --change-batch file://failover-dns.json

    # Update application configuration
    kubectl patch configmap app-config \
        -p '{"data":{"efs_region":"'$REPLICA_REGION'","efs_id":"'$REPLICA_EFS_ID'"}}'

    echo "DR failover completed to $REPLICA_REGION"
fi
```

### Recovery Validation
```bash
# Validate replica accessibility
aws efs describe-file-systems --file-system-id $REPLICA_EFS_ID --region $REPLICA_REGION

# Test mount in replica region
ec2-instance-in-replica-region:~$ sudo mount -t efs $REPLICA_EFS_ID:/ /mnt/efs-test

# Validate data integrity
find /mnt/efs-test -type f -exec md5sum {} \; > replica-checksums.txt
```

## Compliance and Auditing

### SOC2 Compliance Features
- **Encryption**: All data encrypted at rest and in transit
- **Access Controls**: IAM, security groups, and file system policies
- **Audit Logging**: CloudTrail integration for all API calls
- **Network Isolation**: VPC-based deployment
- **Backup**: Automated backup with retention policies

### Audit Trail Setup
```bash
# Enable CloudTrail for EFS API calls
aws cloudtrail create-trail \
    --name efs-audit-trail \
    --s3-bucket-name efs-audit-logs \
    --include-global-service-events \
    --is-multi-region-trail

# Enable VPC Flow Logs
aws ec2 create-flow-logs \
    --resource-type VPC \
    --resource-ids $VPC_ID \
    --traffic-type ALL \
    --log-destination-type cloud-watch-logs \
    --log-group-name /aws/vpc/flowlogs
```

### Compliance Reporting
```bash
# Generate compliance report
aws logs start-query \
    --log-group-name /aws/cloudtrail/efs-audit \
    --start-time $(date -d '30 days ago' +%s) \
    --end-time $(date +%s) \
    --query-string 'fields @timestamp, userIdentity.type, eventName, sourceIPAddress | filter eventSource = "elasticfilesystem.amazonaws.com"'
```

## Troubleshooting

### Performance Issues
```bash
# Monitor real-time throughput
aws cloudwatch get-metric-statistics \
    --namespace AWS/EFS \
    --metric-name ThroughputUtilization \
    --dimensions Name=FileSystemId,Value=$EFS_ID \
    --start-time $(date -d '1 hour ago' -u +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 300 \
    --statistics Average

# Check for I/O bottlenecks
iostat -x 1 10

# Monitor network performance
iperf3 -c <efs-mount-target-ip> -p 2049 -t 60
```

### Security Issues
```bash
# Validate security group rules
aws ec2 describe-security-groups --group-ids $SG_ID

# Check IAM permissions
aws iam simulate-principal-policy \
    --policy-source-arn $ROLE_ARN \
    --action-names elasticfilesystem:ClientMount \
    --resource-arns arn:aws:elasticfilesystem:$REGION:$ACCOUNT:file-system/$EFS_ID

# Verify encryption status
aws efs describe-file-systems --file-system-id $EFS_ID \
    --query 'FileSystems[0].Encrypted'
```

### Replication Issues
```bash
# Check replication status
aws efs describe-replication-configurations \
    --source-file-system-id $EFS_ID

# Monitor replication metrics
aws cloudwatch get-metric-statistics \
    --namespace AWS/EFS \
    --metric-name ReplicationThroughput \
    --dimensions Name=SourceFileSystemId,Value=$EFS_ID \
    --start-time $(date -d '1 hour ago' -u +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 300 \
    --statistics Average
```

## Outputs

| Name | Description |
|------|-------------|
| `efs_id` | Primary EFS file system ID |
| `efs_arn` | Primary EFS file system ARN |
| `efs_dns_name` | DNS name for mounting |
| `kms_key_id` | Custom KMS key ID |
| `kms_key_arn` | Custom KMS key ARN |
| `access_points` | Map of all access points |
| `mount_targets` | Mount target information |
| `security_group_id` | Security group ID |
| `replication_configuration_id` | Replication configuration ID |
| `complete_efs_config` | Complete configuration reference |

## Best Practices Implemented

### Security
- Encryption at rest with custom KMS keys
- Encryption in transit enforced via file system policy
- Network isolation with VPC and security groups
- Access control via IAM, security groups, and access points
- Audit logging with CloudTrail integration

### Performance
- MaxIO performance mode for high throughput
- Provisioned throughput for predictable performance
- Optimized mount options for maximum throughput
- Client-side caching enabled

### Reliability
- Multi-AZ mount targets for high availability
- Cross-region replication for disaster recovery
- Automated backup policies
- Comprehensive monitoring and alerting

### Cost Optimization
- Intelligent lifecycle management
- Right-sized provisioned throughput
- Automated IA transition policies
- Cost allocation tags for tracking

## Next Steps

- Review [basic example](../basic/) for simpler setups
- Check [access points example](../with-access-points/) for multi-tenancy focus
- Explore [replication example](../with-replication/) for DR-focused setup

## Cleanup

```bash
# Disable replication first
aws efs delete-replication-configuration --source-file-system-id $EFS_ID

# Wait for replication to stop
aws efs describe-replication-configurations --source-file-system-id $EFS_ID

# Destroy Terraform resources
terraform destroy
```

**Critical Warning**: This will permanently delete all data in both primary and replica file systems. Ensure all critical data is backed up before proceeding.
