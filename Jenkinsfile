
pipeline {
    agent any

    options {
        // Evita el checkout automático de Jenkins.
        skipDefaultCheckout(true)
    }

    stages {
        stage('1. Clonar Repositorio') {
            steps {
                checkout scm
            }
        }

        stage('2. Validar y planificar Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init -input=false'
                    sh 'terraform fmt -check -recursive'
                    sh 'terraform validate'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('3. Aprobar cambios') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: '¿Quieres aplicar los cambios de Terraform?',
                          ok: 'Aprobar y continuar'
                }
            }
        }

        stage('4. Aplicar Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('5. Configuración Web (Ansible)') {
            steps {
                withCredentials([
                    string(credentialsId: 'vault-key', variable: 'VAULT_PASS')
                ]) {
                    sh '''
                        set +x
                        VAULT_FILE=$(mktemp)
                        trap 'rm -f "$VAULT_FILE"' EXIT

                        printf '%s' "$VAULT_PASS" > "$VAULT_FILE"

                        ansible-playbook \
                            -i ansible/inventory.ini \
                            ansible/playbook.yml \
                            -e "@ansible/password.yml" \
                            --vault-password-file "$VAULT_FILE" \
                            --syntax-check

                        ansible-playbook \
                            -i ansible/inventory.ini \
                            ansible/playbook.yml \
                            -e "@ansible/password.yml" \
                            --vault-password-file "$VAULT_FILE"
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'rm -f terraform/tfplan'
        }
    }
}
