pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        AWS_CREDENTIALS_ID = 'aws-credentials'
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git(credentialsId: GIT_CREDENTIALS_ID, url: 'https://github.com/sanjaykshebbar/ASI-Insurance-DevOps.git', branch: 'main')
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                # Install dependencies like Node.js, AWS CLI, etc.
                sudo apt-get update
                sudo apt-get install -y nodejs npm awscli
                '''
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: AWS_CREDENTIALS_ID,
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region $AWS_REGION
                    
                    aws s3 ls
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('sanjaykshebbar/asi-insurance-app')
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh '''
                    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                    docker push sanjaykshebbar/asi-insurance-app:latest
                    '''
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh '''
                ansible-playbook -i hosts deploy-playbook.yml
                '''
            }
        }
    }

    post {
        always {
            cleanWs() 
        }
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
