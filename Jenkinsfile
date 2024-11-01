pipeline {
    agent any
    environment {
        // These environment variables are populated using Jenkins credentials
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_SESSION_TOKEN = credentials('aws-session-token') // Optional if using temporary token
    }
    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/sanjaykshebbar/ASI-Insurance-DevOps.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                // Initialize Terraform
                sh 'terraform init'

                // Apply Terraform with automatic approval
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Generate a dynamic inventory file using the Terraform output
                    def publicIp = sh(script: 'terraform output -raw instance_ip', returnStdout: true).trim()
                    writeFile file: 'hosts', text: "[ec2_instances]\n${publicIp} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa\n"

                    // Execute the Ansible playbook
                    sh 'ansible-playbook -i hosts deploy-playbook.yml'
                }
            }
        }
    }
}

