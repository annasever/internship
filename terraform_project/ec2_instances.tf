provider "aws" {
  region     = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_instance" "backend" {
  ami                    = var.instance_AMI
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.servers_sg.id]

  tags = {
    Name = "backend"
  }

   root_block_device {
    volume_size = 15
  }

}

resource "aws_instance" "frontend" {
  ami                    = var.instance_AMI
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.servers_sg.id]

  tags = {
    Name = "frontend"
  }

   root_block_device {
    volume_size = 15
  }

}

resource "aws_instance" "databases" {
  ami                    = var.instance_AMI
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.servers_sg.id]

  tags = {
    Name = "databases"
  }

   root_block_device {
    volume_size = 20 
  }
}

resource "null_resource" "install_backend_dependencies" {
  depends_on = [aws_instance.backend]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/vasilenko.pem")
    host        = aws_instance.backend.public_ip
  }
}

resource "null_resource" "install_frontend_dependencies" {
  depends_on = [aws_instance.frontend]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/vasilenko.pem")
    host        = aws_instance.frontend.public_ip
  }
}

resource "null_resource" "install_databases_dependencies" {
  depends_on = [aws_instance.databases]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/vasilenko.pem")
    host        = aws_instance.databases.public_ip
  }
}