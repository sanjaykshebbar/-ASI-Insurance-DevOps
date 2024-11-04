pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        GIT_CREDENTIALS = credentials('github-credentials')
        AWS_SSH_KEY = credentials('aws-ssh-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git credentialsId: 'github-credentials', url: 'https://github.com/sanjaykshebbar/-ASI-Insurance-DevOps.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("sanjaykshebbar/asi-insurance-app:latest")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Terraform Apply: Create EC2') {
            steps {
                dir('terraform-ec2') {
                    script {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                            sh 'terraform init'
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }

        stage('Ansible: Deploy to EC2') {
            steps {
                dir('ansible') {
                    script {
                        def instanceIp = sh(returnStdout: true, script: 'terraform output -raw ec2_instance_public_ip').trim()
                        
                        // Update Ansible hosts file dynamically
                        writeFile file: 'hosts', text: """
                        [ec2]
                        ${instanceIp} ansible_user=ec2-user ansible_ssh_private_key_file=${AWS_SSH_KEY} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
                        """

                        // Run Ansible playbook
                        sh 'ansible-playbook -i hosts deploy-playbook.yml'
                    }
                }
            }
        }
    }
}
