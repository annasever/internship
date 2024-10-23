resource "docker_network" "app_network" {
  name = "app_network"
}


resource "docker_container" "backend" {
  image = docker_image.backend_image.name
  name  = "backend"
  ports {
    internal = 8080
    external = 8080
  }
  env = [
    "POSTGRES_DB=${var.POSTGRES_DB}",
    "POSTGRES_USER=${var.POSTGRES_USER}",
    "POSTGRES_PASSWORD=${var.POSTGRES_PASSWORD}",
    "POSTGRES_PORT=${var.POSTGRES_PORT}",
    "POSTGRES_HOST=${var.POSTGRES_HOST}",
    "REDIS_PORT=${var.REDIS_PORT}",
    "MONGO_INITDB_DATABASE=${var.MONGO_INITDB_DATABASE}",
    "DATABASE_URL=jdbc:postgresql://${var.POSTGRES_HOST}:${var.POSTGRES_PORT}/${var.POSTGRES_DB}"
  ]
  depends_on = [
    docker_container.postgres,
    docker_container.mongo,
    docker_container.redis
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "frontend" {
  image = docker_image.frontend_image.name
  name  = "frontend"
  ports {
    internal = 3000
    external = 3000
  }
  depends_on = [
    docker_container.backend
  ]
  env = [
    "REACT_APP_API_BASE_URL=${var.REACT_APP_API_BASE_URL}",
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_container" "postgres" {
  image = docker_image.postgres_image.name
  name  = "postgres"
  ports {
    internal = var.POSTGRES_PORT
    external = var.POSTGRES_PORT
  }
  env = [
    "POSTGRES_DB=${var.POSTGRES_DB}",
    "POSTGRES_USER=${var.POSTGRES_USER}",
    "POSTGRES_PASSWORD=${var.POSTGRES_PASSWORD}",

  ]

  volumes {
    host_path      = var.DB_DUMP_PATH
    container_path = var.CONTAINER_PATH
  }

  volumes {
    host_path      = abspath(docker_volume.postgres_data.name)
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "mongo" {
  image = docker_image.mongo_image.name
  name  = "mongo"
  ports {
    internal = var.MONGO_PORT
    external = var.MONGO_PORT
  }
  env = [
    "MONGO_INITDB_DATABASE=${var.MONGO_INITDB_DATABASE}"
  ]
  volumes {
    host_path      = "/data/db"
    container_path = "/data/db"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_container" "redis" {
  image = docker_image.redis_image.name
  name  = "redis"
  ports {
    internal = var.REDIS_PORT
    external = var.REDIS_PORT
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
}

