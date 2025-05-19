resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "save_private_key" {
  content  = tls_private_key.pk.private_key_pem
  filename = "${path.module}/private_key.pem"
  file_permission = "0400"
}
