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
                withAWS(credentials:'AWSCredentials') {

                    output = sh ( script: 'aws s3 ls' )

                    if ( output >=0 ) {
                        echo "AWS COnnection Sucessfull"

                    }  else {
                        echo "AWS connection failed"
                    }   
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'cd jenkins-terraform'
                sh 'terraform init'
            }
        }

        stage('Terraform Format') {
            steps {
                sh 'cd jenkins-terraform'
                sh 'terraform fmt --recursive'
            }
        }

        stage('Terraform plan') {
            steps {
                sh 'cd jenkins-terraform'
                sh 'terraform plan'
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