pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "helloworld-app"  // Nama image Docker
        DOCKER_TAG = "latest"            // Tag image
        DOCKER_REGISTRY = "dika007"    // Jika menggunakan Docker Hub
        K8S_DEPLOYMENT_NAME = "helloworld-app-deployment" // Nama deployment di Kubernetes
        K8S_NAMESPACE = "default"        // Namespace Kubernetes 
        GIT_REPO_URL = "https://github.com/dikakurnia07/helloworld.git"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout dari branch 'main'
                git branch: 'main', url: "$GIT_REPO_URL"
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    // bat 'mvn clean install'
                    bat 'docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat 'docker login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%'
                        bat 'docker tag %DOCKER_IMAGE%:%DOCKER_TAG% %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%'
                        bat 'docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update deployment di Kubernetes untuk menggunakan image terbaru
                    bat 'kubectl config set-context docker-desktop --cluster=docker-desktop --user=docker-desktop --namespace=%K8S_NAMESPACE%'
                    bat 'kubectl config use-context docker-desktop'
                    // bat 'kubectl set image deployment/%K8S_DEPLOYMENT_NAME% helloworld-app=%DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG% -n %K8S_NAMESPACE%'
                    bat 'kubectl rollout restart deployment/%K8S_DEPLOYMENT_NAME% -n %K8S_NAMESPACE%'
                    bat 'kubectl rollout status deployment/%K8S_DEPLOYMENT_NAME% -n %K8S_NAMESPACE%'
                    
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deploy succeeded!'
        }
        failure {
            echo 'Build or deploy failed!'
        }
    }
}
