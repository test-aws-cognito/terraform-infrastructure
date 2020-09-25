resource "aws_elasticache_subnet_group" "application_cache" {
  name       = var.TAG_PROJECT
  subnet_ids = var.ALLOWED_SUBNET_IDS
}

resource "aws_elasticache_cluster" "application_cache" {
  cluster_id           = var.TAG_PROJECT
  engine               = "redis"
  node_type            = var.NODE_TYPE
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  security_group_ids   = var.ALLOWED_SECURITY_GROUPS_IDS
  subnet_group_name    = aws_elasticache_subnet_group.application_cache.name
}
