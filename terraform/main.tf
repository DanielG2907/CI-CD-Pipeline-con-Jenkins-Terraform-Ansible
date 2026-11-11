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
  host = var.docker_host
}

# Declaramos la imagen que necesitamos descargar
resource "docker_image" "redis" {
  name         = var.redis_image
  keep_locally = false
}

# Declaramos el contenedor que queremos aprovisionar
resource "docker_container" "redis_server" {
  image = docker_image.redis.image_id
  name  = "servidor_redis_cache"
  
  networks_advanced {
    name = docker_network.red_interna.name
  }
}

# Monitorización con Grafana
resource "docker_image" "grafana" {
  name         = var.grafana_image
  keep_locally = false
}

resource "docker_container" "grafana_server" {
  image = docker_image.grafana.image_id
  name  = "servidor_grafana"

  ports {
    internal = 3000
    external = var.grafana_external_port
  }

  networks_advanced {
    name = docker_network.red_interna.name
  }

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }
}

# Balanceador de Carga (Proxy Inverso Nginx)
resource "docker_image" "nginx" {
  name         = var.nginx_image
  keep_locally = false
}

resource "docker_container" "nginx_lb" {
  image = docker_image.nginx.image_id
  name  = "balanceador_nginx"
  ports {
    internal = 80
    external = var.nginx_external_port
  }
  # Inyectamos la configuración del proxy al vuelo
  upload {
    file    = "/etc/nginx/conf.d/default.conf"
    content = <<-EOF
      upstream backend_web {
          server ${var.backend_1_ip}:80;
          server ${var.backend_2_ip}:80;
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

resource "docker_network" "red_interna" {
  name     = "red_interna"
  driver   = "bridge"
}

resource "docker_volume" "grafana_data" {
  name = "grafana_data"
}