resource "aws_lb" "main_loadbalancer" {
  name               = "${var.app_name}-${var.environment_name}-alb"
  internal           = var.alb_properties.internal
  load_balancer_type = "application"
  subnets            = var.subnet_public
  security_groups    = [aws_security_group.main_load_balancer_sg.id]

}

resource "aws_security_group" "main_load_balancer_sg" {
  name   = "${var.app_name}-${var.environment_name}-loadbalancer-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.main_load_balancer_sg_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.main_load_balancer_sg_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_lb_target_group" "main_targetgroup" {
  count               = length(var.ecs_service_properties)
  name                = "${var.app_name}-${var.environment_name}-targetgroup-${count.index}"
  port                = var.target_group_properties.port
  protocol            = var.target_group_properties.protocol
  target_type         = "ip"
  vpc_id              = var.vpc_id

  health_check {
    healthy_threshold   = var.target_group_properties.health_check.healthy_threshold
    interval            = var.target_group_properties.health_check.interval
    protocol            = var.target_group_properties.health_check.protocol
    matcher             = var.target_group_properties.health_check.matcher
    timeout             = var.target_group_properties.health_check.timeout
    path                = var.target_group_properties.health_check.path
    unhealthy_threshold = var.target_group_properties.health_check.unhealthy_threshold
  }
}


resource "aws_lb_listener" "listener" {
  for_each          = { for idx, listener in var.listeners : idx => listener }
  load_balancer_arn = aws_lb.main_loadbalancer.id
  port              = each.value.port
  protocol          = each.value.protocol

  # Assuming you have a single default action
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_targetgroup[0].id
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  count               = length(var.ecs_service_properties)
  listener_arn        = aws_lb_listener.listener["0"].arn // Assuming port 80 is at index 0

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_targetgroup[count.index].id
  }

  condition {
  path_pattern {
    values = [var.ecs_service_properties[count.index].path_pattern]
  }
}
}
