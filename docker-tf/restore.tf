resource "null_resource" "db_restore" {
  depends_on = [
    docker_container.backend,
    docker_container.postgres
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    environment = {
      POSTGRES_DB       = var.POSTGRES_DB
      POSTGRES_USER     = var.POSTGRES_USER
      POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
    }

    command = "bash ${var.RESTORE_PATH} ${docker_container.postgres.name} ${var.CONTAINER_PATH}"
  }
}
