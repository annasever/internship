provider "aws" {
  region     = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_instance" "prometheus" {
  ami                    = var.instance_AMI
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.prometheus.id]
  iam_instance_profile   = aws_iam_instance_profile.prometheus_iam_instance_profile.name

  tags = {
    Name = "prometheus"
  }

   root_block_device {
    volume_size = 30
  }

}

resource "aws_eip" "prometheus_eip" {
  vpc = true
}

resource "aws_eip_association" "prometheus_eip_assoc" {
  instance_id   = aws_instance.prometheus.id
  allocation_id = aws_eip.prometheus_eip.id
}

resource "null_resource" "install_prometheus_dependencies" {
  depends_on = [aws_instance.prometheus]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/vasilenko.pem")
    host        = aws_instance.prometheus.public_ip
  }
}
