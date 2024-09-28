# Definir chave SSH
resource "aws_key_pair" "this" {
  public_key = file("/home/elvenworks24/.ssh/id_rsa.pub")
  tags = {
    Name = "my-key"
  }
}

#   Declarar a Instância EC2
resource "aws_instance" "wordpress_server" {
  ami                         = var.ami_image
  instance_type               = var.type_instance
  subnet_id                   = aws_subnet.publica1.id
  associate_public_ip_address = true
key_name        = aws_key_pair.this.key_name
  vpc_security_group_ids      = [aws_security_group.sg_wordpress.id]

  user_data = templatefile("ec2Wordpress.sh",
    {
      wp_db_name       = aws_db_instance.bd_wordpress.db_name
      wp_username      = aws_db_instance.bd_wordpress.username
      wp_user_password = aws_db_instance.bd_wordpress.password
      wp_db_host       = aws_db_instance.bd_wordpress.address
  })

  tags = {
    Name = "Wordpress Server"
  }
}
