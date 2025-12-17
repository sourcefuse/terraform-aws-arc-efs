################################################################################
## Data Sources for VPC Resources
################################################################################

# Get arc-poc-vpc VPC
data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["arc-poc-vpc"]
  }
}

# Get private subnets in the default VPC (preferred for EFS mount targets)
data "aws_subnets" "private" {
  filter {
    name = "tag:Name"

    values = [
      "${var.namespace}-${var.environment}-private-subnet-private-${var.region}a",
      "${var.namespace}-${var.environment}-private-subnet-private-${var.region}b"
    ]
  }
}
