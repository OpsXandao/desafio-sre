# Região padrão
variable "region" {
  description = "A região AWS a ser utilizada"
  default     = "us-east-1"
}

# Variáveis da VPC
variable "vpc_cidr" {
  description = "Endereço CIDR da VPC"
}
variable "vpc_name" {
  description = "Nome da VPC"
}
variable "cidr_privada1" {
  description = "Endereço CIDR da primeira subnet privada"
}
variable "cidr_privada2" {
  description = "Endereço CIDR da segunda subnet privada"
}
variable "cidr_publica1" {
  description = "Endereço CIDR da primeira subnet pública"
}
variable "cidr_publica2" {
  description = "Endereço CIDR da segunda subnet pública"
}
variable "nome_privada1" {
  description = "Nome da primeira subnet privada"
}
variable "nome_privada2" {
  description = "Nome da segunda subnet privada"
}
variable "nome_publica1" {
  description = "Nome da primeira subnet pública"
}
variable "nome_publica2" {
  description = "Nome da segunda subnet pública"
}

# Variáveis do EC2
variable "ami_image" {
  description = "ID da AMI para as instâncias"
}
variable "type_instance" {
  description = "Tipo da instância EC2"
}

# Variáveis do BD
variable "allo_stora" {
  description = "Espaço de armazenamento alocado"
}
variable "dbname" {
  description = "Nome do banco de dados"
}
variable "engine" {
  description = "Engine do banco de dados"
}
variable "v_engine" {
  description = "Versão da engine do banco de dados"
}
variable "classinstance" {
  description = "Classe da instância do banco de dados"
}
variable "user" {
  description = "Usuário do banco de dados"
}
variable "password" {
  description = "Senha do banco de dados"
}
variable "parameter_group_name" {
  description = "Nome do grupo de parâmetros do banco de dados"
}
variable "port" {
  description = "Porta do banco de dados"
}
