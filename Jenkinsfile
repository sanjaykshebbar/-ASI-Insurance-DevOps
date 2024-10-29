pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-username/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('asi-insurance-app')
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                            def appImage = docker.build("asi-insurance-app:${env.BUILD_NUMBER}")
                            appImage.push()
                        }
                    }
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                // We’ll add deployment steps here once AWS is configured
                echo 'Deployment stage placeholder'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker images'
            sh 'docker rmi asi-insurance-app'
        }
    }
}
