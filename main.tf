module "minecraft_shared" {
  source      = "./modules/minecraft-shared"
  namespace   = var.namespace
  environment = var.environment
  vpc_cidr    = var.vpc_cidr

  parent_zone_name = "yodo.dev"
  hosted_zone_name = "xcraft.yodo.dev"
}

module "minecraft_server" {
  source            = "./modules/minecraft-server"
  namespace         = var.namespace
  environment       = var.environment
  minecraft_version = var.minecraft_version

  key_name         = module.minecraft_shared.key_name
  vpc_id           = module.minecraft_shared.vpc.vpc_id
  vpc_subnet_ids   = module.minecraft_shared.vpc.public_subnets
  hosted_zone_id   = module.minecraft_shared.hosted_zone_id
  hosted_zone_name = module.minecraft_shared.hosted_zone_name
}
