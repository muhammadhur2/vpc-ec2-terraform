resource "aws_instance" "windows_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_public[1]
  vpc_security_group_ids = [aws_security_group.windows_sg.id]

  tags = {
    Name = "${var.app_name}-${var.environment_name}-windows-ec2"
  }
}

resource "aws_security_group" "windows_sg" {
  name   = "${var.app_name}-${var.environment_name}-windows-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.main_windows_sg_ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
    }
  }

  dynamic "egress" {
    for_each = var.main_windows_sg_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}