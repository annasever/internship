output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}

output "databases_ip" {
  value = aws_instance.databases.public_ip
  description = "Public IP for DataBase instances"
}