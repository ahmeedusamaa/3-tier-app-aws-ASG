module "compute" {
  source = "./modules/compute"
  vpc_id = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids = module.networking.public_subnet_ids
  frontend_sg = module.security_group.frontend_sg_id
  backend_sg = module.security_group.backend_sg_id
  public_key = module.keypair.public_key
  db_password = var.db_password
  db_address = module.storage.database_address
  backend_lb_dns_name = module.loadbalancing.backend_lb_dns_name
}

module "loadbalancing" {
  source = "./modules/loadbalancing"
  frontend_alb_sg = module.security_group.frontend_alb_sg_id
  backend_alb_sg = module.security_group.backend_alb_sg_id
  vpc_id = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  frontend_lb_target_group_arn = module.compute.frontend_lb_target_group_arn
  backend_lb_target_group_arn = module.compute.backend_lb_target_group_arn
}

module "networking" {
  source = "./modules/networking"
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs = var.azs
}

module "security_group" {
  source = "./modules/securitygroup"
  vpc_id = module.networking.vpc_id
  
}

module "storage" {
  source = "./modules/storage"
  db_sg_id = module.security_group.db_sg_id
  db_password = var.db_password
  db_subnet_group = module.networking.database_subnet_group
  
}


module "keypair" {
  source = "./modules/keypair"
  public_key = var.public_key
}