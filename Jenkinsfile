pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        AWS_CREDENTIALS_ID = 'aws-credentials'
        AWS_REGION = 'us-east-1'
        SUDO_CREDENTIALS_ID = 'sudo-credentials' // ID of the sudo credential you created
    }

    stages {
        stage('Checkout') {
            steps {
                git(credentialsId: GIT_CREDENTIALS_ID, url: 'https://github.com/sanjaykshebbar/ASI-Insurance-DevOps.git', branch: 'main')
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Use credentials to run commands requiring sudo
                    withCredentials([usernamePassword(credentialsId: SUDO_CREDENTIALS_ID, usernameVariable: 'SUDO_USER', passwordVariable: 'SUDO_PASS')]) {
                        sh '''
                        echo "$SUDO_PASS" | sudo -S ./install_dependencies.sh
                        '''
                    }
                }
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
                # Set locale for UTF-8 for Ansible
                export LANG=en_US.UTF-8
                export LANGUAGE=en_US.UTF-8
                export LC_ALL=en_US.UTF-8
                
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
