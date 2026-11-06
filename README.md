# 🚀 Home Lab: CI/CD Pipeline con Jenkins, Terraform y Ansible

Este proyecto es un entorno de laboratorio DevOps diseñado para demostrar la automatización del ciclo de vida de la infraestructura y configuración utilizando un enfoque de Infraestructura como Código (IaC).

## 🏗️ Arquitectura del Proyecto

El entorno está desplegado sobre máquinas virtuales gestionadas localmente y orquestado de forma centralizada:

*   **Nodo Central (Orquestador):** Servidor Rocky Linux alojando Jenkins en un contenedor Docker con permisos sobre el socket del host.
*   **Nodos Destino (Web Servers):** Dos servidores Ubuntu Server gestionados sin agente (Agentless) vía SSH.
*   **Servicios Auxiliares:** Contenedores de caché (Redis) aprovisionados dinámicamente en el Nodo Central.

## 🛠️ Stack Tecnológico

*   **Integración Continua (CI/CD):** Jenkins (Pipeline Declarativo)
*   **Aprovisionamiento (IaC):** Terraform (Provider Docker)
*   **Gestión de Configuración:** Ansible
*   **Control de Versiones:** Git & GitHub

## ⚙️ Flujo del Pipeline (Jenkinsfile)

El pipeline automatizado consta de tres fases secuenciales:

1.  **Checkout SCM:** Jenkins clona la última versión del repositorio desde la rama `main`.
2.  **Aprovisionamiento (Terraform):** Se inicializan los módulos y se ejecuta `terraform apply -auto-approve` para levantar la infraestructura auxiliar requerida (ej. servidor de caché Redis) sobre el motor Docker del Nodo Central.
3.  **Configuración (Ansible):** Se ejecuta el playbook `playbook.yml` a través del inventario estático. Ansible se conecta por SSH a los nodos Ubuntu, instala dependencias (Nginx) y asegura que los servicios estén activos y expuestos.

## 🔒 Consideraciones de Seguridad
*   Autenticación entre el Nodo Central y los Clientes gestionada exclusivamente mediante claves SSH `ed25519` (sin contraseñas en texto plano).
*   Elevación de privilegios en los nodos destino configurada mediante directivas seguras de `sudoers` (NOPASSWD para el usuario de automatización).