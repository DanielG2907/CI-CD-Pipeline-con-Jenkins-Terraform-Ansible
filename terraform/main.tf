terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# Nos conectamos al motor de Docker local del Nodo Central
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Declaramos la imagen que necesitamos descargar
resource "docker_image" "redis" {
  name         = "redis:alpine"
  keep_locally = false
}

# Declaramos el contenedor que queremos aprovisionar
resource "docker_container" "redis_server" {
  image = docker_image.redis.image_id
  name  = "servidor_redis_cache"
  ports {
    internal = 6379
    external = 6379
  }
}