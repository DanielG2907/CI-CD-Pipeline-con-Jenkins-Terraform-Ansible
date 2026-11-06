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

# Monitorización con Grafana
resource "docker_image" "grafana" {
  name         = "grafana/grafana:latest"
  keep_locally = false
}

resource "docker_container" "grafana_server" {
  image = docker_image.grafana.image_id
  name  = "servidor_grafana"
  ports {
    internal = 3000
    external = 3000
  }
}

# Balanceador de Carga (Proxy Inverso Nginx)
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_container" "nginx_lb" {
  image = docker_image.nginx.image_id
  name  = "balanceador_nginx"
  ports {
    internal = 80
    external = 80
  }
  # Inyectamos la configuración del proxy al vuelo
  upload {
    file    = "/etc/nginx/conf.d/default.conf"
    content = <<-EOF
      upstream backend_web {
          server 192.168.208.50:80;
          server 192.168.208.51:80;
      }
      server {
          listen 80;
          location / {
              proxy_pass http://backend_web;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
          }
      }
    EOF
  }
}