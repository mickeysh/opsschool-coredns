resource "tls_private_key" "coredns_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "coredns_key" {
  key_name   = "coredns_key"
  public_key = "${tls_private_key.coredns_key.public_key_openssh}"
}

resource "local_file" "coredns_key" {
  sensitive_content  = "${tls_private_key.coredns_key.private_key_pem}"
  filename           = "coredns_key.pem"
}
