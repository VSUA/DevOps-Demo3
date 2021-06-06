resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > ./${var.key_name}.pem"
  }
}

resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = var.instances_count
  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    Name  = "Instance-${count.index + 1}"
  }
}
