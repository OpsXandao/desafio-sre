# Variáveis da VPC
vpc_cidr = "10.0.0.0/16"
vpc_name = "main-vpc"

cidr_publica1 = "10.0.3.0/24"
cidr_publica2 = "10.0.4.0/24"
cidr_privada1 = "10.0.1.0/24"
cidr_privada2 = "10.0.2.0/24"
nome_publica1 = "sub-publica1"
nome_publica2 = "sub-publica2"
nome_privada1 = "sub-privada1"
nome_privada2 = "sub-privada2"

# Váriaveis das Intâncias
ami_image     = "ami-04505e74c0741db8d"
type_instance = "t3.micro"

#Variáveis BD

allo_stora           = 10
dbname               = "wordpress_db"
engine               = "mysql"
v_engine             = "8.0"
classinstance        = "db.t3.micro"
user                 = "alexandrep"
password             = "opsganhei;"
parameter_group_name = "default.mysql8.0"
port                 = 3306

