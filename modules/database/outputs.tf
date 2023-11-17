output "database_url" {
  value = "postgresql://${aws_db_instance.main_db.username}:${aws_db_instance.main_db.password}@${aws_db_instance.main_db.endpoint}/${aws_db_instance.main_db.db_name}"
}
