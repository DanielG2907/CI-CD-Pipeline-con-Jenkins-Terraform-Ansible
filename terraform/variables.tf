variable "docker_host" {
  description = "Socket del motor Docker"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "backend_1_ip" {
  description = "IP del primer servidor web"
  type        = string
  default     = "192.168.208.50"
}

variable "backend_2_ip" {
  description = "IP del segundo servidor web"
  type        = string
  default     = "192.168.208.51"
}

variable "nginx_external_port" {
  description = "Puerto de acceso al balanceador"
  type        = number
  default     = 80
}

variable "grafana_external_port" {
  description = "Puerto de acceso a Grafana"
  type        = number
  default     = 3000
}

variable "redis_image" {
  type    = string
  default = "redis:7.4.2-alpine"
}

variable "grafana_image" {
  type    = string
  default = "grafana/grafana:11.6.0"
}

variable "nginx_image" {
  type    = string
  default = "nginx:1.28-alpine"
}