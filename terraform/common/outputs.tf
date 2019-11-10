output "vpc_id" {
  description = "Id of the shared VPC"
  value       = aws_vpc.main.id
}

output "public-subnet-a-id" {
  description = "Id of public subnet a"
  value       = aws_subnet.public-a.id
}

output "public-subnet-b-id" {
  description = "Id of public subnet b"
  value       = aws_subnet.public-b.id
}
