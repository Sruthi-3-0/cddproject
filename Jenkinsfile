pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')  // Jenkins credentials ID for DockerHub
        IMAGE_NAME = 'sruthikanneti/cddproject'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Sruthi-3-0/cddproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    // Stop any previous container using the same image (optional but good practice)
                    bat 'for /f "tokens=*" %i in (\'docker ps -q --filter "ancestor=%IMAGE_NAME%:%IMAGE_TAG%"\') do docker stop %i'

                    // Run container on port 3001
                    bat "docker run -d -p 3001:80 %IMAGE_NAME%:%IMAGE_TAG%"

                    echo "Application is now running at: http://localhost:3001"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
