pipeline {
    agent any

    environment {
        AWS_REGION     = 'ap-south-1'
        AWS_ACCOUNT_ID = '213375652280'
        IMAGE_REPO     = 'brain-task-app'
        IMAGE_TAG      = "${BUILD_NUMBER}"   // or 'latest'
        ECR_REGISTRY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        KUBECONFIG     = "/var/lib/jenkins/.kube/config"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'gitcred', url: 'https://github.com/Viki07-14/Braintask.git'
            }
        }

        stage('Verify AWS Identity') {
            steps {
                sh 'aws sts get-caller-identity'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                  aws ecr get-login-password --region $AWS_REGION | 
                  docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build --no-cache -t $IMAGE_REPO:latest .
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh '''
                  docker tag $IMAGE_REPO:latest $ECR_REGISTRY/$IMAGE_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                  docker push $ECR_REGISTRY/$IMAGE_REPO:$IMAGE_TAG
                '''
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                sh '''
                echo "Deploying to EKS..."
                ./scripts/deploy.sh
                '''
            }
        }
    }

    post {
        success {
            echo "Image pushed successfully: $ECR_REGISTRY/$IMAGE_REPO:$IMAGE_TAG"
        }
        failure {
            echo "Build or push failed"
        }
    }
}
