output "public_ip" {
  value = aws_instance.webapp-server.public_ip
}


output "public_dns" {
  value = aws_instance.webapp-server.public_dns

}

