# Criação do sistema de arquivos EFS
resource "aws_efs_file_system" "wordpress_efs" {
  creation_token = "wordpress-efs"  # Nome único do EFS
  tags = {
    Name = "wordpress-efs"  # Nome do EFS
  }
}

# Criação dos pontos de montagem do EFS nas subnets públicas
resource "aws_efs_mount_target" "wordpress_efs_mt_a" {
  file_system_id  = aws_efs_file_system.wordpress_efs.id  # ID do sistema de arquivos EFS
  subnet_id       = aws_subnet.publica1.id  # Subnet pública onde o EFS será acessível
  security_groups = [aws_security_group.sg_wordpress.id]  # Grupo de segurança associado ao EFS
}

resource "aws_efs_mount_target" "wordpress_efs_mt_b" {
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.publica2.id  # Outra subnet pública
  security_groups = [aws_security_group.sg_wordpress.id]
}
