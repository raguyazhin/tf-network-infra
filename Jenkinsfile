pipeline {
    agent any

    // environment {
    //     TF_VAR_access_key = credentials('AWS_ACCESS_KEY_ID')
    //     TF_VAR_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
    // }


    stages {

        stage('Checkout') {
            steps {
                script {
                    checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/raguyazhin/tf-network-infra.git']])
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Using withCredentials to inject AWS credentials
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                        credentialsId: 'ragu_aws_credentials'
                    ]]) {
                        // Your Terraform commands here
                        sh 'terraform init'                      
                    }
                }
            }
        }

        stage('Terraform Plan and Apply') {
            steps {
                script {
                    // Using withCredentials to inject AWS credentials
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                        credentialsId: 'ragu_aws_credentials'
                    ]]) {
                        // Your Terraform commands here
                        sh 'terraform plan -var-file=env/dev.tfvars'
                        sh 'terraform plan -var-file=env/prod.tfvars'
                        sh 'terraform apply -var-file=env/dev.tfvars -auto-approve'
                        sh 'terraform apply -var-file=env/prod.tfvars -auto-approve'
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    // Using withCredentials to inject AWS credentials
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                        credentialsId: 'ragu_aws_credentials'
                    ]]) {
                        // Your Terraform commands here
                        sh 'terraform destroy -var-file=env/dev.tfvars -auto-approve'
                        sh 'terraform destroy -var-file=env/prod.tfvars -auto-approve'
                    }
                }
            }
        }

    }

    post {
        always {
            script {
                // Clean up workspace and other post-build tasks
                deleteDir()
            }
        }
    }
}
