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


module "ec2-windows" {
  source                          = "../modules/ec2-windows"
  vpc_id                          = module.vpc.vpc_id
  subnet_public                   = module.vpc.subnet_public
  app_name                        = var.app_name
  environment_name                = var.environment_name
  main_windows_sg_egress        = var.main_windows_sg_egress
  main_windows_sg_ingress       = var.main_windows_sg_ingress
  ami_id = var.ami_id
  instance_type = var.instance_type


  depends_on = [module.vpc]

}

# module "frontend" {
#   source                              = "../modules/frontend"
#   app_name                            = var.app_name
#   environment_name                    = var.environment_name
#   sse_algorithm                       = var.sse_algorithm
#   s3_frontend_public_block_properties = var.s3_frontend_public_block_properties
#   cloudfront_distribution_properties  = var.cloudfront_distribution_properties
# }

# module "ecs" {
#   source                          = "../modules/ecs"
#   vpc_id                          = module.vpc.vpc_id
#   subnet_public                   = module.vpc.subnet_public
#   listener_arn                    = module.loadbalancer.listener_arn
#   load_balancer_security_group_id = module.loadbalancer.load_balancer_security_group_id
#   target_group_arn                = module.loadbalancer.target_group_arn
#   ecs_task_definition_properties  = var.ecs_task_definition_properties
#   ecs_cluster_properties          = var.ecs_cluster_properties
#   ecs_service_properties          = var.ecs_service_properties
#   ecs_task_execution_role_arn     = module.iam.ecs_task_execution_role_arn
#   app_name                        = var.app_name
#   environment_name                = var.environment_name
#   main_container_sg_egress        = var.main_container_sg_egress
#   main_container_sg_ingress       = var.main_container_sg_ingress
#   database_url = module.database.database_url


#   depends_on = [module.vpc, module.iam]

# }

# module "database" {
#   source           = "../modules/database"
#   db_properties    = var.db_properties
#   vpc_id           = module.vpc.vpc_id
#   subnet_db        = module.vpc.subnet_db
#   vpc_sec_grp      = [module.vpc.vpc_sec_grp]
#   public_access    = var.public_access
#   app_name         = var.app_name
#   environment_name = var.environment_name

#   depends_on       = [module.vpc]
# }


# module "loadbalancer" {
#   source                        = "../modules/loadbalancer"
#   vpc_id                        = module.vpc.vpc_id
#   subnet_public                 = module.vpc.subnet_public
#   alb_properties                = var.alb_properties
#   target_group_properties       = var.target_group_properties
#   app_name                      = var.app_name
#   environment_name              = var.environment_name
#   main_load_balancer_sg_egress  = var.main_load_balancer_sg_egress
#   main_load_balancer_sg_ingress = var.main_load_balancer_sg_ingress
#   ecs_service_properties = var.ecs_service_properties
#   listeners = var.listeners
#   ecs_service_names = module.ecs.ecs_service_names

#   depends_on       = [module.vpc]

# }

# module "iam" {
#   source                = "../modules/iam"
#   iam_policy_properties = var.iam_policy_properties
#   app_name              = var.app_name
#   environment_name      = var.environment_name

# }



# # module "backends3" {
# #   source = "../modules/backends3"
# # }