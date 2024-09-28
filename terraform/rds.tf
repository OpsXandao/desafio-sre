#Configuração Banco de Dados
resource "aws_db_instance" "bd_wordpress" {
  allocated_storage      = var.allo_stora
  db_name                = var.dbname
  engine                 = var.engine
  engine_version         = var.v_engine
  instance_class         = var.classinstance
  username               = var.user
  password               = var.password
  port                   = var.port
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_rds.id]

  lifecycle {
    ignore_changes = [password]
  }
}