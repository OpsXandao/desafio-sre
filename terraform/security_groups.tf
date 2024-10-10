# Grupo de Segurança para EC2 (WordPress)
resource "aws_security_group" "sg_wordpress" {
  name        = "permitir_ssh_http_no"
  description = "Allow SSH, HTTP, and Node Exporter inbound traffic"
  vpc_id      = aws_vpc.main.id  # Referência à VPC principal

  # Regras de entrada (Ingress)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso de qualquer origem para SSH
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego HTTP (porta 80)
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego HTTPS (porta 443)
  }

  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego para monitoramento (Node Exporter)
  }

  # Regras de saída (Egress)
egress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_memcached.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]  # Permite todo o tráfego de saída
    ipv6_cidr_blocks = ["::/0"]       # Permite todo o tráfego IPv6 de saída
  }

  # Tags para o Grupo de Segurança
  tags = {
    Name = "allow_ssh_http_node"
  }
}

# Grupo de Segurança para o RDS (Banco de Dados)
resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow MySQL traffic from EC2 instances"
  vpc_id      = aws_vpc.main.id  # Referência à VPC principal

  # Regras de entrada (Ingress)
  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]  # Permite acesso ao MySQL somente dentro da VPC
  }

  # Regras de saída (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permite todo o tráfego de saída
  }

  # Tags para o Grupo de Segurança
  tags = {
    Name = "allow_rds"
  }
}

# Regras de Grupo de Segurança para o EFS
resource "aws_security_group_rule" "allow_efs" {
  type              = "ingress"
  from_port         = 2049  # Porta NFS
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_wordpress.id  # Referência ao grupo de segurança do WordPress
  cidr_blocks       = ["0.0.0.0/0"]  # Permite acesso de qualquer origem para EFS
}

# Grupo de Segurança para Memcached
resource "aws_security_group" "sg_memcached" {
  name        = "sg_memcached"
  description = "Security group for the Memcached cluster"
  vpc_id      = aws_vpc.main.id  # Referência à VPC principal

  # Regras de entrada (Ingress)
  ingress {
    from_port   = 11211  # Porta padrão do Memcached
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.publica1.cidr_block, aws_subnet.publica2.cidr_block]  # Permite acesso das subnets públicas
  }

  # Regras de saída (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permite todo o tráfego de saída
  }

  # Tags para o Grupo de Segurança
  tags = {
    Name = "allow-memcached"
  }
}

# Grupo de Segurança para EC2 privada com Docker
resource "aws_security_group" "sg_private" {
  name        = "private-ec-sg"
  description = "Security Group for Private EC2 Instance with Docker"
  vpc_id      = aws_vpc.main.id  # Referência à VPC principal

  # Regras de entrada (Ingress)
  ingress {
    from_port   = 22  # Porta SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Permite acesso SSH apenas dentro da VPC
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego VPN
  }

  ingress {
    from_port   = 80  # Porta 80 para o servidor web no Docker
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Apenas tráfego interno na VPC
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Permite tráfego HTTPS (porta 443)
  }

  ingress {
    from_port   = 8080  # Porta 8080 para o servidor Docker
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego externo na porta 8080
  }

  # Regras de saída (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permite todo o tráfego de saída, incluindo acesso à Internet
  }

  # Tags para o Grupo de Segurança
  tags = {
    Name = "sg-private-ec2"
  }
}

# Grupo de Segurança para VPN (Pritunl)
resource "aws_security_group" "vpn_sg" {
  name        = "VPN"
  description = "Allow incoming connections to monitor machine"
  vpc_id      = aws_vpc.main.id  # Referência à VPC principal

  # Regras de entrada (Ingress)
  ingress {
    from_port   = 22  # Porta SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso SSH de qualquer origem
  }

  ingress {
    from_port   = 80  # Porta HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego HTTP
  }

  ingress {
    from_port   = 443  # Porta HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego HTTPS
  }

  ingress {
    from_port   = 8080  # Porta 8080 para o servidor Docker
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego externo na porta 8080
  }  

  ingress {
    from_port   = -1  # ICMP (ping)
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite ICMP de qualquer origem
  }

  ingress {
    from_port   = 3000  # Porta para serviços customizados
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego de qualquer origem
  }

  ingress {
    from_port   = 9090  # Porta para monitoramento
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego de monitoramento
  }

  ingress {
    from_port   = 9100  # Porta Node Exporter
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego para Node Exporter
  }

  ingress {
    from_port   = 9091  # Porta adicional para monitoramento
    to_port     = 9091
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego de monitoramento
  }

  ingress {
    from_port   = 1194  # Porta VPN
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego VPN de qualquer origem
  }

  # Regras de saída (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permite todo o tráfego de saída
  }

  # Tags para o Grupo de Segurança
  tags = {
    Name = "VPN"
  }
}
