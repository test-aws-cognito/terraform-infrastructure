output "HOST" {
  // TODO: this sounds like problems
  value = aws_elasticache_cluster.application_cache.cache_nodes[0].address
}

output "PORT" {
  value = aws_elasticache_cluster.application_cache.port
}
