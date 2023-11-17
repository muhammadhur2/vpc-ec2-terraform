resource "aws_db_instance" "main_db" {
  identifier             = "${var.app_name}${var.environment_name}rdsinstance"
  allocated_storage      = var.db_properties["db1"].allocated_storage
  db_name                = "${var.app_name}${var.environment_name}database"
  engine                 = var.db_properties["db1"].engine
  instance_class         = var.db_properties["db1"].instance_class
  username               = var.db_properties["db1"].username
  password               = var.db_properties["db1"].password
  skip_final_snapshot    = var.db_properties["db1"].skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.main_db_subnetgrp.name
  vpc_security_group_ids = var.vpc_sec_grp
  publicly_accessible    = var.public_access

}

resource "aws_db_subnet_group" "main_db_subnetgrp" {
  name       = "${var.app_name}-${var.environment_name}-db-subnet-group"
  subnet_ids = var.subnet_db
}

