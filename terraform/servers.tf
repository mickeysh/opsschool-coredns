# Get Ubuntu AMI information 
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Get Subnet Id for the VPC
data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

#Monitoring Security Group
resource "aws_security_group" "coredns_sg" {
  name        = "coredns_sg"
  description = "Security group for monitoring server"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP from control host IP
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all SSH External
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic to HTTP port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    # Allow all traffic to HTTP port 8080
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1053
    to_port     = 1053
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1053
    to_port     = 1053
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allocate the EC2 monitoring instance
resource "aws_instance" "core_dns" {
  count         = var.number_of_server
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id              = element(tolist(data.aws_subnet_ids.subnets.ids), count.index)
  vpc_security_group_ids = [aws_security_group.coredns_sg.id]
  key_name               = aws_key_pair.coredns_key.key_name

  associate_public_ip_address = true

  tags = {
    Owner = var.owner
    Name  = "coredns-${count.index}"
  }
  
  connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${tls_private_key.coredns_key.private_key_pem}"
      host = self.public_ip
  }

  provisioner "file" {
    source      = "script/install_coredns.sh"
    destination = "/tmp/install_coredns.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_coredns.sh",
      "/tmp/install_coredns.sh",
    ]
  }
}

output "servers_public_ip" {
  value = join(",", aws_instance.core_dns.*.public_ip)
}

output "servers_private_ip" {
  value = join(",", aws_instance.core_dns.*.private_ip)
}
