resource "aws_instance" "frontend_instance" {
  ami                    = var.instance_AMI
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.tf_server_sg.id]

  tags = {
    Name = "frontend_instance"
  }
}

resource "null_resource" "install_frontend_dependencies" {
  depends_on = [aws_instance.frontend_instance]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/vasilenko.pem")
    host        = aws_instance.frontend_instance.public_ip
  }

  provisioner "file" {
    source      = "/home/anna/aws-tf/scripts/install.sh"
    destination = "/home/ubuntu/install.sh"
  }

  provisioner "file" {
    source      = "/home/anna/aws-tf/scripts/frontend.sh"
    destination = "/home/ubuntu/frontend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install.sh",
      "chmod +x /home/ubuntu/frontend.sh",
      "/home/ubuntu/install.sh",
      "/home/ubuntu/frontend.sh"
    ]
  }
}
