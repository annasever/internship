output "backend_private_ip" {
  value = aws_instance.backend_instance.public_ip
}

output "frontend_private_ip" {
  value = aws_instance.frontend_instance.public_ip
}

output "postgres_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "mongo_endpoint" {
  value = aws_docdb_cluster.mongo.endpoint
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}
