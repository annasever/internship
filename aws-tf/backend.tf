provider "aws" {
  region     = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_instance" "backend_instance" {
  ami                    = var.instance_AMI
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.tf_server_sg.id]

  tags = {
    Name = "backend_instance"
  }
}

resource "null_resource" "install_backend_dependencies" {
  depends_on = [aws_instance.backend_instance]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/vasilenko.pem")
    host        = aws_instance.backend_instance.public_ip
  }

  provisioner "file" {
    source      = "/home/anna/aws-tf/scripts/install.sh"
    destination = "/home/ubuntu/install.sh"
  }

  provisioner "file" {
    source      = "/home/anna/aws-tf/scripts/backend.sh"
    destination = "/home/ubuntu/backend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install.sh",
      "chmod +x /home/ubuntu/backend.sh",
      "/home/ubuntu/install.sh",
      "/home/ubuntu/backend.sh"
    ]
  }
}
