

output "vpc_id" {
  value = aws_vpc.terraform-project.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}
