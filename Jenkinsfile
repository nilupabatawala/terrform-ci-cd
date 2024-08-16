pipeline {
    agent any

    environment {
        // Retrieve credentials stored in Jenkins
        TF_VAR_public_subnet_cidrs = credentials('public_subnet_cidrs')
        TF_VAR_private_subnet_cidrs = credentials('private_subnet_cidrs')
        TF_VAR_cidr = credentials('cidr')
        TF_VAR_azs = credentials('azs')
        TF_VAR_azs_private = credentials('azs_private')
        TF_VAR_ami = credentials('ami')
        TF_VAR_instance_type= credentials('instance_type')

    }


    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nilupabatawala/fastapi-rabbitmq-app.git'
            }
        }
        

        stage('Check AWS COnnectivity') {
            steps {

                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                    sh 'aws s3 ls'
                }
                   
            }
        }

        stage('Create tfvars File') {
            steps {
                script {
                    // Create terraform.tfvars file dynamically
                    writeFile file: 'terraform.tfvars', text: """
                    cidr                 = "${env.TF_VAR_cidr}"
                    public_subnet_cidrs  = "${env.TF_VAR_public_subnet_cidrs}"
                    private_subnet_cidrs = "${env.TF_VAR_private_subnet_cidrs}"
                    azs                  = "${env.TF_VAR_azs}"
                    azs_private          = "${env.TF_VAR_azs_private}"
                    ami                  = "${env.TF_VAR_ami}"
                    instance_type        = "${env.TF_VAR_instance_type}"
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                sh 'cd jenkins-terraform; terraform init -no-color'
                }
            }
        }

        stage('Terraform Format') {
            steps {
                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                sh 'cd jenkins-terraform; terraform fmt --recursive -no-color'
                }
            }
        }

        stage('Terraform plan') {
            steps {
                withCredentials([aws(credentialsId: 'AWSCredentials')]) {
                sh 'cd jenkins-terraform;terraform plan -out=tfplan.out -no-color'
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
