resource "aws_elasticache_subnet_group" "redis" {
  name        = "redis-subnet-group"
  description = "Subnet group for Redis cluster"
  subnet_ids  = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 1
  port                 = 6379
  parameter_group_name = "default.redis7"

  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = var.security_group_ids

  tags = {
    Name    = "redis-elasticache"
    Service = "redis"
  }
}
