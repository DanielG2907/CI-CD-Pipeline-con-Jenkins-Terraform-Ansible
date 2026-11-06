pipeline {
    agent any

    stages {
        stage('1. Clonar Repositorio') {
            steps {
                // Descarga el código desde GitHub
                checkout scm
            }
        }
        
        stage('2. Test de Conectividad SSH') {
            steps {
                // Jenkins usa el binario de Ansible del host para hacer un ping a los clientes
                sh 'ansible -i ansible/inventory.ini webservers -m ping'
            }
        }
        
        stage('3. Configuración (Ansible)') {
            steps {
                // Ejecuta el playbook para instalar Nginx en todos los clientes
                sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
            }
        }
    }
}