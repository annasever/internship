output "frontend_ip" {
  value = aws_instance.frontend_instance.public_ip
}

output "backend_ip" {
  value = aws_instance.backend_instance.public_ip
}