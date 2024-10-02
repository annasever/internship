output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}

output "postgres_ip" {
  value = aws_instance.postgres.public_ip
  description = "Public IP of the PostgreSQL instance"
}

output "mongo_ip" {
  value = aws_instance.mongo.public_ip
  description = "Public IP of the MongoDB instance"
}

output "redis_ip" {
  value = aws_instance.redis.public_ip
  description = "Public IP of the Redis instance"
}