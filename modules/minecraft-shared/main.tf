locals {
  tags = {
    "Namespace"   = var.namespace
    "Environment" = var.environment
  }

  num_azs = min(var.max_azs, length(data.aws_availability_zones.azs.names))
}

data "aws_availability_zones" "azs" {
  state = "available"
}

# Create a basic VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14.2"
  tags    = local.tags

  cidr             = var.vpc_cidr
  private_subnets  = [for i in range(0, local.num_azs) : cidrsubnet(var.vpc_cidr, 8, i)]      # ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  database_subnets = [for i in range(0, local.num_azs) : cidrsubnet(var.vpc_cidr, 8, 10 + i)] # ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  public_subnets   = [for i in range(0, local.num_azs) : cidrsubnet(var.vpc_cidr, 8, 20 + i)] # ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway

  name = "${var.environment}-${var.namespace}"
  azs  = slice(data.aws_availability_zones.azs.names, 0, local.num_azs)
}

data "aws_route53_zone" "parent" {
  name = var.parent_zone_name
}

resource "aws_route53_zone" "rz" {
  name = var.hosted_zone_name
  tags = local.tags
}

resource "aws_route53_record" "ns" {
  zone_id = data.aws_route53_zone.parent.id
  name    = aws_route53_zone.rz.name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.rz.name_servers
}

# SSH keypair (throwaway)
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name_prefix = var.namespace
  public_key      = tls_private_key.keypair.public_key_openssh
  tags            = local.tags
}
