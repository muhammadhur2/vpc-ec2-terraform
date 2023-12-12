module "vpc" {
  source                     = "../modules/vpc"
  vpc_cidr                   = var.vpc_cidr
  subnets-public             = var.subnets-public
  subnets-private            = var.subnets-private
  availability_zones = data.aws_availability_zones.available.names
  app_name                   = var.app_name
  environment_name           = var.environment_name
  main_securitygroup_egress  = var.main_securitygroup_egress
  main_securitygroup_ingress = var.main_securitygroup_ingress
}


# module "ec2-windows" {
#   source                          = "../modules/ec2-windows"
#   vpc_id                          = module.vpc.vpc_id
#   subnet_public                   = module.vpc.subnet_public
#   app_name                        = var.app_name
#   environment_name                = var.environment_name
#   main_windows_sg_egress        = var.main_windows_sg_egress
#   main_windows_sg_ingress       = var.main_windows_sg_ingress
#   ami_id = var.ami_id
#   instance_type = var.instance_type


#   depends_on = [module.vpc]

# }

module "ec2-instances" {
  source              = "../modules/ec2-instances"
  vpc_id              = module.vpc.vpc_id
  subnet_public       = module.vpc.subnet_public
  app_name            = var.app_name
  environment_name    = var.environment_name
  instances           = var.instances

  depends_on = [module.vpc]
}