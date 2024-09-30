# Declaração do Grupo de Segurança + Suas regras de entrada e Saída do EC2 - Wordpress
resource "aws_security_group" "sg_wordpress" {
  name        = "pemitir ssh, http, no"
  description = "Allow SSH, HTTP, and Node Exporter inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http_node"
  }
}
 
# Declaração do Grupo de Segurança + Suas regras de entrada e Saída do RDS
resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow MySQL traffic from EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rds"
  }
}

# Adiciona a permissão no Security Group para o EFS
resource "aws_security_group_rule" "allow_efs" {
  type              = "ingress"
  from_port         = 2049  # Porta NFS
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_wordpress.id  # Grupo de segurança associado ao EFS
  cidr_blocks       = ["0.0.0.0/0"]  # Permite acesso de qualquer instância EC2
}

resource "aws_security_group" "sg_memcached" {
  name        = "sg_memcached"
  description = "Security group for the Memcached cluster"  # Alterei a descrição para inglês e removi caracteres especiais
  vpc_id      = aws_vpc.main.id 

  ingress {
    from_port   = 11211  # Porta padrão do Memcached
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.publica1.cidr_block, aws_subnet.publica2.cidr_block]  # Permitir acesso das subnets públicas
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir todo o tráfego de saída
  }
}

resource "aws_security_group" "sg_private" {
  name        = "private-ec-sg"
  description = "Security Group for Private EC2 Instance with Docker"
  vpc_id      = aws_vpc.main.id

  # Regras de entrada (Ingress)
  ingress {
    from_port   = 22  # Acesso SSH, você pode remover se não precisar de acesso direto
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Permite acesso apenas da VPC interna
  }


ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80  # Porta 80 para o servidor web no container Docker
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Apenas dentro da VPC (substitua conforme necessário)
  }

  # Regras de saída (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir todo o tráfego de saída
  }

  tags = {
    Name = "sg-private-ec2"
  }
}

# Pritunl Security Group

resource "aws_security_group" "vpn_sg" {
  name        = "VPN"
  description = "Allow incoming connections to monitor machine"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22 # ssh
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80 # http
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443 # https
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9091
    to_port     = 9091
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags =  { 
    Name = "allow-vpn" 
    }
}