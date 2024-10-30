pipeline {
    agent any

    stages {
        stage('Clone Repository') {
    steps {
        script {
            echo 'Cloning the repository from GitHub...'
            git branch: 'main', url: 'https://github.com/sanjaykshebbar/ASI-Insurance-DevOps.git'
        }
    }
}

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building the Docker image...'
                    try {
                        docker.build('asi-insurance-app')
                    } catch (Exception e) {
                        echo "Error building Docker image: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        error "Build failed."
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        echo 'Pushing the Docker image to Docker Hub...'
                        try {
                            docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                                def appImage = docker.build("asi-insurance-app:${env.BUILD_NUMBER}")
                                appImage.push()
                            }
                        } catch (Exception e) {
                            echo "Error pushing Docker image: ${e.message}"
                            currentBuild.result = 'FAILURE'
                            error "Push failed."
                        }
                    }
                }
            }
        }

        stage('Setup EC2 Dependencies with Ansible') {
            steps {
                script {
                    echo 'Setting up dependencies on EC2 instance...'
                    try {
                        sh "ansible-playbook -i 107.20.103.212, -u ubuntu --private-key ~/.ssh/my-key.pem setup-dependencies.yml"
                    } catch (Exception e) {
                        echo "Error setting up dependencies: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        error "Setup failed."
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
            steps {
                script {
                    echo 'Deploying the Docker image on EC2 instance...'
                    try {
                        // Adjust this command based on your deployment needs
                        sh "ssh -i ~/.ssh/my-key.pem ubuntu@107.20.103.212 'docker run -d -p 80:80 asi-insurance-app:${env.BUILD_NUMBER}'"
                    } catch (Exception e) {
                        echo "Error deploying Docker image: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        error "Deployment failed."
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker rmi asi-insurance-app || true' // Remove the image, ignoring errors
        }
    }
}
