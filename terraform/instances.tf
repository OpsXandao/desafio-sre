# Define uma chave SSH para acesso às instâncias EC2
resource "aws_key_pair" "this" {
  key_name   = "terraformed-key"                          # Nome da chave SSH
  public_key = file("/home/elvenworks24/.ssh/id_rsa.pub") # Define a chave pública SSH a partir do arquivo local

  # Tags para identificar a chave
  tags = {
    Name = "my-key" # Nome da chave SSH para identificação
  }
}

# Configuração de lançamento (Launch Configuration) das instâncias EC2
resource "aws_launch_configuration" "wordpress_launch_config" {
  name            = "wordpress-launch-configuration"     # Nome da configuração de lançamento
  image_id        = var.ami_image                        # ID da AMI para o WordPress
  instance_type   = var.type_instance                    # Tipo de instância EC2
  key_name        = aws_key_pair.this.key_name           # Nome da chave SSH para acesso às instâncias
  security_groups = [aws_security_group.sg_wordpress.id] # Grupo de segurança associado à instância

  # Script de inicialização (user data) que instala e configura o WordPress nas instâncias EC2
  user_data = templatefile("ec2Wordpress.sh", {
    wp_db_name       = aws_db_instance.bd_wordpress.db_name,               # Nome do banco de dados do WordPress
    wp_username      = aws_db_instance.bd_wordpress.username,              # Usuário do banco de dados
    wp_user_password = aws_db_instance.bd_wordpress.password,              # Senha do banco de dados
    wp_db_host       = aws_db_instance.bd_wordpress.address,               # Endereço do banco de dados
    efs_id           = aws_efs_file_system.wordpress_efs.id                # ID do EFS dinâmico
    efs_access_point = aws_efs_access_point.wordpress_efs_access_point.id, # ID do ponto de acesso
    memcached_endpoint = aws_elasticache_cluster.memcached_cluster.cache_nodes[0].address
  })
}

# Criação de um Auto Scaling Group para as instâncias EC2 que executam o WordPress
resource "aws_autoscaling_group" "wordpress_asg" {
  launch_configuration      = aws_launch_configuration.wordpress_launch_config.id # Usa a configuração de lançamento definida acima
  min_size                  = 2                                                   # Número mínimo de instâncias no Auto Scaling Group
  max_size                  = 3                                                   # Número máximo de instâncias no Auto Scaling Group
  desired_capacity          = 2                                                   # Capacidade desejada (número de instâncias inicialmente)
  health_check_grace_period = 240
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.publica1.id, aws_subnet.publica2.id] # Múltiplas subnets para alta disponibilidade

  # Associação com o Target Group do ALB
  target_group_arns = [aws_lb_target_group.wordpress_tg.arn]

  # Tags para as instâncias criadas pelo Auto Scaling Group
  tag {
    key                 = "Name"
    value               = "WordPress Server"
    propagate_at_launch = true # Propaga a tag para todas as instâncias ao iniciar
  }

  # Dependências para garantir a ordem de criação correta
  depends_on = [
    aws_lb_listener.wordpress_listener,
    aws_lb_target_group.wordpress_tg,
    aws_lb.wordpress_alb,
    aws_db_instance.bd_wordpress,
    aws_security_group.allow_rds,
    aws_security_group.sg_wordpress
  ]
}

# Criação de um Application Load Balancer (ALB) para distribuir o tráfego entre as instâncias EC2
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"                                  # Nome do Load Balancer
  internal           = false                                            # Define que o ALB é externo (público)
  load_balancer_type = "application"                                    # Tipo de ALB
  security_groups    = [aws_security_group.sg_wordpress.id]             # Grupo de segurança associado ao ALB
  subnets            = [aws_subnet.publica1.id, aws_subnet.publica2.id] # Subnets onde o ALB será lançado

  # Tags para o Load Balancer
  tags = {
    Name = "WordPress ALB"
  }
}

# Grupo de destinos (target group) associado ao ALB
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"  # Nome do target group
  port     = 80              # Porta na qual o ALB irá redirecionar o tráfego
  protocol = "HTTP"          # Protocolo de comunicação
  vpc_id   = aws_vpc.main.id # ID da VPC

  # Configuração da verificação de saúde (health check) para as instâncias
  health_check {
    path                = "/"    # Caminho da verificação de saúde
    protocol            = "HTTP" # Protocolo da verificação de saúde
    healthy_threshold   = 2      # Número de respostas positivas para considerar a instância saudável
    unhealthy_threshold = 2      # Número de respostas negativas para considerar a instância não saudável
    timeout             = 5      # Tempo limite da verificação
    interval            = 30     # Intervalo entre as verificações
  }

  # Tags para o target group
  tags = {
    Name = "WordPress Target Group"
  }
}

# Listener do ALB para ouvir na porta 80 e redirecionar o tráfego para o target group
resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn # Associa o listener ao ALB
  port              = 80                       # Porta de entrada do tráfego no ALB
  protocol          = "HTTP"                   # Protocolo utilizado pelo listener

  # Ação padrão do listener: redirecionar o tráfego para o target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn # Redireciona o tráfego para o target group
  }
}

# Associa o grupo de Auto Scaling ao target group do Load Balancer
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name # Nome do grupo de Auto Scaling
  lb_target_group_arn    = aws_lb_target_group.wordpress_tg.arn     # ARN do target group
}

# Política de Auto Scaling para aumentar a capacidade quando a CPU estiver alta
resource "aws_autoscaling_policy" "scale_up" {
  name                    = "scale-up-policy"                        # Nome da política
  scaling_adjustment      = 1                                        # Aumenta a capacidade do Auto Scaling Group em 1 instância
  adjustment_type         = "ChangeInCapacity"                       # Tipo de ajuste (alteração na capacidade)
  cooldown                = 300                                      # Período de espera antes de permitir outro ajuste
  autoscaling_group_name  = aws_autoscaling_group.wordpress_asg.name # Nome do grupo de Auto Scaling
  metric_aggregation_type = "Average"                                # Tipo de agregação da métrica
}

# Política de Auto Scaling para reduzir a capacidade quando a CPU estiver baixa
resource "aws_autoscaling_policy" "scale_down" {
  name                    = "scale-down-policy"                      # Nome da política
  scaling_adjustment      = -1                                       # Reduz a capacidade do Auto Scaling Group em 1 instância
  adjustment_type         = "ChangeInCapacity"                       # Tipo de ajuste (alteração na capacidade)
  cooldown                = 300                                      # Período de espera antes de permitir outro ajuste
  autoscaling_group_name  = aws_autoscaling_group.wordpress_asg.name # Nome do grupo de Auto Scaling
  metric_aggregation_type = "Average"                                # Tipo de agregação da métrica
}

# Alarme do CloudWatch para monitorar alta utilização de CPU
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high"                             # Nome do alarme
  comparison_operator = "GreaterThanOrEqualToThreshold"        # Condição de comparação
  evaluation_periods  = 2                                      # Número de períodos de avaliação antes de acionar o alarme
  metric_name         = "CPUUtilization"                       # Métrica monitorada (utilização de CPU)
  namespace           = "AWS/EC2"                              # Namespace da métrica
  period              = 60                                     # Duração do período em segundos
  statistic           = "Average"                              # Estatística da métrica (média)
  threshold           = 80                                     # Limite para acionar o alarme (80% de utilização de CPU)
  alarm_description   = "This metric monitors CPU utilization" # Descrição do alarme
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name # Nome do grupo de Auto Scaling associado
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn] # Ação a ser executada (escalar para cima)
}

# Alarme do CloudWatch para monitorar baixa utilização de CPU
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu_low"                              # Nome do alarme
  comparison_operator = "LessThanOrEqualToThreshold"           # Condição de comparação
  evaluation_periods  = 2                                      # Número de períodos de avaliação antes de acionar o alarme
  metric_name         = "CPUUtilization"                       # Métrica monitorada (utilização de CPU)
  namespace           = "AWS/EC2"                              # Namespace da métrica
  period              = 60                                     # Duração do período em segundos
  statistic           = "Average"                              # Estatística da métrica (média)
  threshold           = 20                                     # Limite para acionar o alarme (20% de utilização de CPU)
  alarm_description   = "This metric monitors CPU utilization" # Descrição do alarme
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name # Nome do grupo de Auto Scaling associado
  }

  alarm_actions = [aws_autoscaling_policy.scale_down.arn] # Ação a ser executada (escalar para baixo)
}

resource "aws_instance" "docker_instance" {
  ami             = var.ami_image
  instance_type   = var.type_instance
  subnet_id       = aws_subnet.privada1.id
  key_name        = aws_key_pair.this.key_name
  security_groups = [aws_security_group.sg_private.id]
  user_data = file("ec2Docker.sh")

  tags = {
    Name = "Hello-World"
  }

}

# EC2 Instance para o Pritunl
resource "aws_instance" "this" {
  ami             = var.ami_image              # ID da AMI para a 
  instance_type   = var.type_instance          # Tipo de instância EC2
  key_name        = aws_key_pair.this.key_name # Nome da chave SSH para acesso às instâncias
  security_groups = [aws_security_group.vpn_sg.id]
  user_data = base64encode(
  templatefile("pritunl.sh", {}))
  monitoring                  = true
  subnet_id                   = aws_subnet.publica1.id
  associate_public_ip_address = true

  tags = {
    Name = "Pritunl"
  }
}
