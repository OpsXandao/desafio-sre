# Criação de um cluster do ElastiCache para Memcached
resource "aws_elasticache_cluster" "memcached_cluster" {
  cluster_id           = "wordpress-memcached"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"

  # Referência ao grupo de sub-rede
  subnet_group_name    = aws_elasticache_subnet_group.memcached_subnet_group.name

  # Segurança do cluster Memcached
  security_group_ids   = [aws_security_group.sg_memcached.id]

  tags = {
    Name = "WordPress Memcached"
  }
}
