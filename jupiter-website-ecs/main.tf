# configure aws provider
provider "aws" {
  region    = var.region
  profile   = "terraform-user"
}

# create vpc
module "vpc" {
  source                            = "../modules/vpc"
  region                            = var.region
  project_name                      = var.project_name
  vpc_cidr                          = var.vpc_cidr
  public_subnet_az1_cidr            = var.public_subnet_az1_cidr
  public_subnet_az2_cidr            = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr       = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr       = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr      = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr      = var.private_data_subnet_az2_cidr
}

# create nat gateways
module "nat_gateway" {
  source                            = "../modules/nat-gateway"
  public_subnet_az1_id              = module.vpc.public_subnet_az1_id
  public_subnet_az2_id              = module.vpc.public_subnet_az2_id
  internet_gateway                  = module.vpc.internet_gateway
  vpc_id                            = module.vpc.vpc_id
  private_app_subnet_az1_id         = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id        = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id         = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id        = module.vpc.private_data_subnet_az2_id
}

# create security groups
module "security-groups" {
  source                            = "../modules/security-groups"
  vpc_id                            = module.vpc.vpc_id
}

# create iam role 
module "ecs-task-execution-role" {
  source                            = "../modules/ecs-task-execution-role"
  project_name                      = module.vpc.project_name
}

# create certificate
module "acm" {
  source                            = "../modules/acm"
  domain_name                       = var.domain_name
  alternative_name                  = var.alternative_name
}