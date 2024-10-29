pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'asi-insurance-app'
        SSH_KEY_PATH = '/var/jenkins_home/.ssh/id_rsa' // Update this to your Jenkins SSH key path
        ANSIBLE_PLAYBOOK = 'deploy-playbook.yml'      // Your Ansible playbook
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the repository from the specified branch
                    git branch: 'main', url: 'https://github.com/sanjaykshebbar/ASI-Insurance-DevOps.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    def appImage = docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                            // Tag and push the Docker image
                            def appImage = docker.image(DOCKER_IMAGE_NAME)
                            appImage.tag("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                            appImage.push("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                        }
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Execute the Ansible playbook
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
            // Remove the built image
            sh "docker rmi ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} || true" // Ignore errors if the image is not found
            // Optionally clean up dangling images
            sh "docker rmi \$(docker images -f 'dangling=true' -q) || true"
        }
    }
}
