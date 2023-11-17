output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
output "subnet_public" {
  value = [for subnet in aws_subnet.subnet_public : subnet.id]
}

output "subnet_private" {
  value = [for subnet in aws_subnet.subnet_private : subnet.id]
}

# output "subnet_db" {
#   value = [for subnet in aws_subnet.subnet_db : subnet.id]
# }


output "vpc_sec_grp" {
  value = aws_security_group.main_securitygroup.id
}
