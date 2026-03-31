module "network" {
  source = "./modules/network"
  aws_region = var.aws_region
  cidr_block_main_vpc = var.cidr_block_main_vpc
  cidr_block_public_subnet_a = var.cidr_block_public_subnet_a
  cidr_block_public_subnet_b = var.cidr_block_public_subnet_b
  cidr_block_private_subnet_a = var.cidr_block_private_subnet_a
  cidr_block_private_subnet_b = var.cidr_block_private_subnet_b
}

module "security" {
  source = "./modules/security"
  main-vpc-id = module.network.vpc_id 
}

module "compute" {
  source = "./modules/compute"
  public-subnet-a-id = module.network.public-subnet-a-id
  private-subnet-a-id = module.network.private-subnet-a-id
  public-subnet-b-id = module.network.public-subnet-b-id
  private-subnet-b-id = module.network.private-subnet-b-id
  web-server-sg-id = module.security.web-server-sg-id
  target_group_arn = module.loadbalancer.target_group_arn
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  main-vpc-id = module.network.vpc_id
  alb-sg-id = module.security.alb-sg-id
  public-subnet-a-id = module.network.public-subnet-a-id
  public-subnet-b-id = module.network.public-subnet-b-id
  //target_instances_ids = module.compute.instance_ids
}
