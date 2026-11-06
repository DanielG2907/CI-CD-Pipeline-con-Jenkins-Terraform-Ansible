pipeline {
    agent any

    stages {
        stage('1. Clonar Repositorio') {
            steps {
                checkout scm
            }
        }
        
        stage('2. Aprovisionamiento (Terraform)') {
            steps {
                // Entramos a la carpeta terraform, inicializamos y aplicamos los cambios sin preguntar
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        
        stage('3. Configuración Web (Ansible)') {
            steps {
                // En un entorno real, '--vault-password-file' desencriptaría password.yml
                sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -e "@ansible/password.yml"'
            }
        }
    }
}