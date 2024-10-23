variable "POSTGRES_DB" {
  type = string
}

variable "POSTGRES_USER" {
  type = string
}

variable "POSTGRES_PASSWORD" {
  type = string
}

variable "POSTGRES_PORT" {
  type = number
}

variable "POSTGRES_HOST" {
  type = string
}

variable "MONGO_INITDB_DATABASE" {
  type = string
}

variable "MONGO_PORT" {
  type = number
}

variable "REDIS_PORT" {
  type = number
}

variable "REACT_APP_API_BASE_URL" {
  type = string
}

variable "DB_DUMP_PATH" {
  type = string
}

variable "RESTORE_PATH" {
  type = string
}

variable "CONTAINER_PATH" {
  type = string
}
