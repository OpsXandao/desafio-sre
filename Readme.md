## Solução SRE: WordPress com Alta Disponibilidade, Docker e VPN na AWS

Este projeto Terraform foi desenvolvido para provisionar uma infraestrutura robusta na Amazon Web Services (AWS), destinada a hospedar uma aplicação WordPress. A solução foi arquitetada para garantir alta disponibilidade, escalabilidade, otimização de desempenho por meio de caching e a implementação de containers Docker em uma instância privada, acessível apenas via VPN. A seguir, detalhamos os principais componentes e decisões de arquitetura que compõem esta solução.

## Como usar
Para usar o repositório do GitHub fornecido e implantar a infraestrutura com o Terraform, siga estas etapas detalhadas:

1. Clone o Repositório: O primeiro passo é clonar o repositório que contém a configuração do Terraform. Abra o terminal e execute o seguinte comando:

git clone https://github.com/OpsXandao/desafio-sre

2. Acesse o Diretório Terraform: Após clonar o repositório, navegue até a pasta onde estão os arquivos do Terraform. Execute:
 
cd terraform

3. Inicialize o Terraform: O comando `terraform init` prepara o ambiente para a execução do Terraform. Ele baixa os plugins necessários e configura o diretório de trabalho. Execute:

4. Planeje a Infraestrutura: Antes de aplicar as alterações, é importante revisar o que será criado, alterado ou destruído. Para fazer isso, execute:
 
terraform plan -var-file="aws.tfvars"
  
Esse comando lê as variáveis definidas no arquivo `aws.tfvars` e gera um plano de execução, mostrando o que o Terraform fará sem aplicar as mudanças.

5. Aplique as Alterações: Se o plano estiver correto e você estiver pronto para implementar a infraestrutura, execute:

terraform apply -var-file="aws.tfvars"
   
 O Terraform solicitará sua confirmação antes de prosseguir. Digite `yes` para confirmar e iniciar o processo de criação dos recursos na AWS de acordo com a configuração especificada.

## Link para documentação do projeto

https://drive.google.com/file/d/10dCip1_160iEaHZdxtc2thelmlENTBL7/view?usp=sharing

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.wordpress_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.cpu_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_instance.bd_wordpress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_efs_file_system.wordpress_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.wordpress_efs_mt_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_efs_mount_target.wordpress_efs_mt_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_eip.ip-nat-gateway-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.ip-nat-gateway-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_elasticache_cluster.memcached_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.memcached_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_instance.docker_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.internet-gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_configuration.wordpress_launch_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.wordpress_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.wordpress_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.wordpress_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.nat-gateway-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.nat-gateway-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.privada1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.privada2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.publica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.privada1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.privada2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.publica1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.publica2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg_memcached](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg_wordpress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpn_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.privada1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.privada2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.publica1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.publica2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allo_stora"></a> [allo\_stora](#input\_allo\_stora) | Espaço de armazenamento alocado | `any` | n/a | yes |
| <a name="input_ami_image"></a> [ami\_image](#input\_ami\_image) | ID da AMI para as instâncias | `any` | n/a | yes |
| <a name="input_cidr_privada1"></a> [cidr\_privada1](#input\_cidr\_privada1) | Endereço CIDR da primeira subnet privada | `any` | n/a | yes |
| <a name="input_cidr_privada2"></a> [cidr\_privada2](#input\_cidr\_privada2) | Endereço CIDR da segunda subnet privada | `any` | n/a | yes |
| <a name="input_cidr_publica1"></a> [cidr\_publica1](#input\_cidr\_publica1) | Endereço CIDR da primeira subnet pública | `any` | n/a | yes |
| <a name="input_cidr_publica2"></a> [cidr\_publica2](#input\_cidr\_publica2) | Endereço CIDR da segunda subnet pública | `any` | n/a | yes |
| <a name="input_classinstance"></a> [classinstance](#input\_classinstance) | Classe da instância do banco de dados | `any` | n/a | yes |
| <a name="input_dbname"></a> [dbname](#input\_dbname) | Nome do banco de dados | `any` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine do banco de dados | `any` | n/a | yes |
| <a name="input_nome_privada1"></a> [nome\_privada1](#input\_nome\_privada1) | Nome da primeira subnet privada | `any` | n/a | yes |
| <a name="input_nome_privada2"></a> [nome\_privada2](#input\_nome\_privada2) | Nome da segunda subnet privada | `any` | n/a | yes |
| <a name="input_nome_publica1"></a> [nome\_publica1](#input\_nome\_publica1) | Nome da primeira subnet pública | `any` | n/a | yes |
| <a name="input_nome_publica2"></a> [nome\_publica2](#input\_nome\_publica2) | Nome da segunda subnet pública | `any` | n/a | yes |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Nome do grupo de parâmetros do banco de dados | `any` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Senha do banco de dados | `any` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | Porta do banco de dados | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | A região AWS a ser utilizada | `string` | `"us-east-1"` | no |
| <a name="input_type_instance"></a> [type\_instance](#input\_type\_instance) | Tipo da instância EC2 | `any` | n/a | yes |
| <a name="input_user"></a> [user](#input\_user) | Usuário do banco de dados | `any` | n/a | yes |
| <a name="input_v_engine"></a> [v\_engine](#input\_v\_engine) | Versão da engine do banco de dados | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Endereço CIDR da VPC | `any` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Nome da VPC | `any` | n/a | yes |

