resource "aws_ecr_repository" "main_ecr" {
  count = length(var.ecs_service_properties)
  name  = "${var.app_name}-${var.environment_name}-${var.ecs_service_properties[count.index].container_name}-ecr"
}



resource "aws_ecs_task_definition" "main_task_definition" {
  count                   = length(var.ecs_service_properties)
  family                  = "${var.app_name}-${var.environment_name}-taskdef-${count.index}"
  network_mode            = var.ecs_task_definition_properties.network_mode
  cpu                     = var.ecs_task_definition_properties.cpu
  memory                  = var.ecs_task_definition_properties.memory
  execution_role_arn      = var.ecs_task_execution_role_arn
  requires_compatibilities = var.ecs_task_definition_properties.requires_compatibilities

container_definitions = <<DEFINITION
[
  {
    "name": "${var.app_name}-${var.environment_name}-container-${count.index}",
    "image": "${var.ecs_task_definition_properties.container_image}",
    "cpu": ${var.ecs_task_definition_properties.container_cpu},
    "memory": ${var.ecs_task_definition_properties.container_memory},
    "essential": true,
    "environment": [
      {
        "name": "DATABASE_URL",
        "value": "${var.database_url}"
      }
    ],
    "portMappings": [
      {
        "containerPort": ${var.ecs_service_properties[count.index].container_port},
        "hostPort": ${var.ecs_task_definition_properties.host_port},
        "protocol": "tcp"
      }
    ],
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.main_log_group.name}",
        "awslogs-region": "${var.ecs_task_definition_properties.log_region}",
        "awslogs-stream-prefix": "${var.ecs_task_definition_properties.log_stream_prefix}"
      }
    }
  }
]
DEFINITION
}
resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.app_name}-${var.environment_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_properties.container_insights
  }
}




resource "aws_ecs_service" "main_ecs_service" {
  count                 = length(var.ecs_service_properties)
  name                  = "${var.app_name}-${var.environment_name}-ecs-service-${count.index}"
  cluster               = aws_ecs_cluster.main_cluster.id
  task_definition       = aws_ecs_task_definition.main_task_definition[count.index].arn
  launch_type           = var.ecs_service_properties[count.index].launch_type
  scheduling_strategy   = "REPLICA"
  desired_count         = var.ecs_service_properties[count.index].desired_count
  force_new_deployment  = var.ecs_service_properties[count.index].force_new_deployment

  network_configuration {
    subnets          = var.subnet_public
    assign_public_ip = var.ecs_service_properties[count.index].assign_public_ip
    security_groups  = [aws_security_group.main_container_sg.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn[count.index]
    container_name   = "${var.app_name}-${var.environment_name}-container-${count.index}"
    container_port   = var.ecs_service_properties[count.index].container_port
  }
}





resource "aws_security_group" "main_container_sg" {
  name   = "${var.app_name}-${var.environment_name}-container-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.main_container_sg_ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = [var.load_balancer_security_group_id]
    }
  }

  dynamic "egress" {
    for_each = var.main_container_sg_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}


resource "aws_cloudwatch_log_group" "main_log_group" {
  name = var.ecs_task_definition_properties.log_group
}
