resource "docker_image" "frontend_image" {
  name = "annasever/class_schedule-frontend:latest"
}

resource "docker_image" "backend_image" {
  name = "annasever/class_schedule-backend:latest"
}

resource "docker_image" "postgres_image" {
  name = "postgres:latest"
}

resource "docker_image" "mongo_image" {
  name = "mongo:latest"
}

resource "docker_image" "redis_image" {
  name = "redis:latest"
}
