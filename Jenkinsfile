pipeline {
    agent any

    environment {
        TF_VAR_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
    }


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
                    sh 'terraform init -var-file=env/dev.tfvars'
                    sh 'terraform init -var-file=env/prod.tfvars'
                }
            }
        }

        stage('Terraform Plan') {
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
                    }
                }
            }
        }



        // stage('Terraform Plan') {
        //     steps {
        //         script {
        //             sh 'terraform plan -var-file=env/dev.tfvars'
        //             sh 'terraform plan -var-file=env/prod.tfvars'
        //         }
        //     }
        // }

        // stage('Terraform Apply') {
        //     steps {
        //         script {
        //             sh 'terraform apply -var-file=env/dev.tfvars -auto-approve'
        //             sh 'terraform apply -var-file=env/prod.tfvars -auto-approve'
        //         }
        //     }
        // }

        // stage('Terraform Destroy') {
        //     steps {
        //         script {
        //             input 'Do you really want to destroy the infrastructure?'

        //             sh 'terraform destroy -auto-approve'
        //         }
        //     }
        // }
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
