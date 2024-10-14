# Configuração do Banco de Dados do  WordPress
resource "aws_db_instance" "bd_wordpress" {
  allocated_storage      = var.allo_stora                           # Espaço de armazenamento alocado para o banco de dados
  db_name                = var.dbname                               # Nome do banco de dados
  engine                 = var.engine                               # Motor de banco de dados, como MySQL ou PostgreSQL
  engine_version         = var.v_engine                             # Versão do motor do banco de dados
  instance_class         = var.classinstance                        # Tipo da instância do banco de dados (ex: db.t2.micro)
  username               = var.user                                 # Nome de usuário do banco de dados
  password               = var.password                             # Senha do banco de dados
  port                   = var.port                                 # Porta usada pelo banco de dados
  parameter_group_name   = var.parameter_group_name                 # Grupo de parâmetros do banco de dados para configurações customizadas
  skip_final_snapshot    = true                                     # Define se deve pular o snapshot final ao destruir a instância
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name # Grupo de sub-rede para a instância RDS
  vpc_security_group_ids = [aws_security_group.allow_rds.id]        # Grupo de segurança para permitir acesso ao RDS
  multi_az               = true                                     # Alta disponibilidade

  # O ciclo de vida ignora alterações de senha para evitar que o Terraform faça mudanças na instância ao alterar a senha
  lifecycle {
    ignore_changes = [password] # Ignora alterações na senha para evitar recriação da instância
  }

  # Tags para identificar o banco de dados
  tags = {
    Name = "WordPress Database" # Nome da instância de banco de dados para identificação
  }
}
