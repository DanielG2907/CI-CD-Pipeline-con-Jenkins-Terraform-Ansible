# 🚀 Home Lab: CI/CD Pipeline con Jenkins, Terraform y Ansible (DevSecOps)

Este proyecto es un entorno de laboratorio DevOps diseñado para demostrar la automatización del ciclo de vida de la infraestructura, gestión de configuración y seguridad utilizando un enfoque de Infraestructura como Código (IaC).

## 🏗️ Arquitectura del Proyecto y Alta Disponibilidad

*   **Nodo Central (Orquestador):** Servidor Rocky Linux alojando Jenkins.
*   **Balanceador de Carga:** Contenedor Nginx actuando como Proxy Inverso (Round-Robin) para repartir el tráfico web de forma equitativa.
*   **Nodos Destino (Web Servers):** Dos servidores Ubuntu Server gestionados sin agente (Agentless) vía SSH.
*   **Observabilidad:** Contenedor de Grafana para la visualización de métricas de infraestructura.

## 🛠️ Stack Tecnológico

*   **CI/CD:** Jenkins (Pipeline Declarativo)
*   **Aprovisionamiento (IaC):** Terraform (Provider Docker)
*   **Gestión de Configuración:** Ansible
*   **Seguridad y Secretos:** Ansible Vault (DevSecOps)
*   **Control de Versiones:** Git & GitHub

## ⚙️ Flujo del Pipeline Automatizado

1.  **Checkout SCM:** Extracción del código fuente desde GitHub.
2.  **Aprovisionamiento de Infraestructura:** Terraform despliega dinámicamente el balanceador de carga Nginx y el servidor de monitorización Grafana.
3.  **Inyección de Secretos:** Jenkins recupera credenciales seguras y las inyecta temporalmente en el entorno.
4.  **Despliegue y Configuración:** Ansible desencripta el archivo `password.yml` mediante Vault, se conecta a los nodos Ubuntu, instala dependencias web y configura el contenido estático.