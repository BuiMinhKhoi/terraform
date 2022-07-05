output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "private-subnet-id" {
  value = aws_subnet.private-subnet.id
}

output "security-group-id" {
  value       = aws_security_group.security-group.id
}
