resource "aws_elasticache_cluster" "memcached_cluster" {
  # Define o ID do cluster para identificação
  cluster_id = "wordpress-memcached"

  # Especifica que o engine do cluster será Memcached
  engine = "memcached"

  # Define o tipo de instância para o nó do cache
  node_type = "cache.t2.micro"

  # Especifica o número de nós de cache no cluster (neste caso, 1)
  num_cache_nodes = 1

  # Define o grupo de parâmetros que será usado para configurar o Memcached
  parameter_group_name = "default.memcached1.6"

  # Referência ao grupo de sub-rede que define onde o cluster será criado
  subnet_group_name = aws_elasticache_subnet_group.memcached_subnet_group.name

  # Referência ao grupo de segurança que controlará o tráfego de rede
  security_group_ids = [aws_security_group.sg_memcached.id]

  # Adiciona tags ao cluster para facilitar a identificação e categorização
  tags = {
    Name = "WordPress Memcached"
  }
}
