pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'asi-insurance-app'
        SSH_KEY_PATH = '~/.ssh/id_rsa'            // Path to your private SSH key
        ANSIBLE_PLAYBOOK = 'deploy-playbook.yml'  // Your Ansible playbook
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/sanjaykshebbar/ASI-Insurance-DevOps.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                            def appImage = docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                            appImage.push()
                        }
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    sh """
                    ansible-playbook -i localhost, -u sanjayks --private-key ${SSH_KEY_PATH} ${ANSIBLE_PLAYBOOK}
                    """
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                echo 'Deployment stage placeholder' // Placeholder for AWS deployment
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker images'
            sh "docker rmi ${DOCKER_IMAGE_NAME} || true" // Ignore errors if the image is not found
        }
    }
}
