resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "PostgreSQL Subnet Group"
  }
}

resource "aws_docdb_subnet_group" "mongo_subnet_group" {
  name       = "mongo-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "MongoDB Subnet Group"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Redis Subnet Group"
  }
}

# PostgreSQL RDS
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  db_name              = "db_postgres"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = "password"
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.name
  skip_final_snapshot  = true
}

# MongoDB DocumentDB
resource "aws_docdb_cluster" "mongo" {
  cluster_identifier   = "schedule-cluster"
  engine               = "docdb"
  master_username      = "myadminuser"
  master_password      = "password"
  db_subnet_group_name = aws_docdb_subnet_group.mongo_subnet_group.name
  skip_final_snapshot  = true
}

# Redis ElastiCache
resource "aws_elasticache_cluster" "redis" {
  cluster_id        = "schedule-redis"
  engine            = "redis"
  node_type         = "cache.t3.micro"
  num_cache_nodes   = 1
  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name
}

