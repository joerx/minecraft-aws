locals {
  tags = {
    "app:namespace" = var.namespace
    "app:env"       = var.environment
  }

  max_azs = 3
  num_azs = max(local.max_azs, length(data.aws_availability_zones.azs.names))
}

data "aws_availability_zones" "azs" {
  state = "available"
}

# Create a basic VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14.2"

  cidr             = var.vpc_cidr
  private_subnets  = [for i in range(0, local.num_azs) : cidrsubnet(var.vpc_cidr, 8, i)]      # ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  database_subnets = [for i in range(0, local.num_azs) : cidrsubnet(var.vpc_cidr, 8, 10 + i)] # ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  public_subnets   = [for i in range(0, local.num_azs) : cidrsubnet(var.vpc_cidr, 8, 20 + i)] # ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Not HA, but saves some money

  name = "${var.namespace}-vpc"
  azs  = slice(data.aws_availability_zones.azs.names, 0, local.num_azs)

  tags = local.tags
}

module "minecraft_server" {
  source            = "./modules/minecraft-server"
  namespace         = var.namespace
  environment       = var.environment
  minecraft_version = "1.19.2"
  vpc_id            = module.vpc.vpc_id
  vpc_subnet_ids    = module.vpc.public_subnets
}
