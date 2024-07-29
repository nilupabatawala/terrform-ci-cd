pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nilupabatawala/terrform-ci-cd.git'
            }
        }
        

        stage('Check AWS COnnectivity') {
            steps {

                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                    sh 'aws s3 ls'
                }
                   
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                sh 'cd jenkins-terraform'
                sh 'ls -l'
                sh 'terraform init -no-color'
                }
            }
        }

        stage('Terraform Format') {
            steps {
                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                sh 'cd jenkins-terraform'
                sh 'ls -l'
                sh 'terraform fmt --recursive -no-color'
                }
            }
        }

        stage('Terraform plan') {
            steps {
                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                sh 'cd jenkins-terraform'
                sh 'ls -l'
                sh 'terraform plan -no-color'
                }
            }
        }

        stage('Terraform apply') {
            steps {
                echo 'Terraform apply'
            }
        }

        stage('Terraform verify') {
            steps {
                echo 'Terraform verify'
            }
        }
    }
}