resource "aws_instance" "windows_server" {
  for_each = var.instances

  ami                     = each.value.ami_id
  instance_type           = each.value.instance_type
  subnet_id               = var.subnet_public[each.value.subnet_index]
  vpc_security_group_ids  = [aws_security_group.instance_sg[each.key].id]

  tags = {
    Name = "${var.app_name}-${var.environment_name}-windows-ec2-${each.key}"
  }
}

resource "aws_security_group" "instance_sg" {
  for_each = var.instances

  name   = "${var.app_name}-${var.environment_name}-windows-sg-${each.key}"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.sg_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.sg_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

