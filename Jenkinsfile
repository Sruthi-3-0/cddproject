pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Jenkins credentials ID for DockerHub
        IMAGE_NAME = 'sruthikanneti/cddproject'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Debug: Environment Info') {
            steps {
                echo "Jenkins Build Number: ${IMAGE_TAG}"
                echo "Docker Image: ${IMAGE_NAME}:${IMAGE_TAG}"
                bat 'docker --version'
                bat 'echo Current directory is: %CD%'
            }
        }

        stage('Clone Repository') {
            steps {
                echo "Cloning repository..."
                git branch: 'main', url: 'https://github.com/Sruthi-3-0/cddproject.git'
                bat 'dir'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
                bat 'docker images'
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
                bat 'docker images'
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    echo "Deploying Docker container using image: ${IMAGE_NAME}:${IMAGE_TAG}"

                    // Stop previous container(s) using this image
                    echo "Stopping existing container(s) with the same image if running..."
                    bat '''
                        FOR /F "tokens=*" %%i IN ('docker ps -q --filter "ancestor=%IMAGE_NAME%:%IMAGE_TAG%"') DO (
                            echo Stopping container ID: %%i
                            docker stop %%i
                        )
                    '''

                    // Run container on port 3001
                    echo "Starting new container..."
                    bat "docker run -d -p 3001:80 %IMAGE_NAME%:%IMAGE_TAG%"

                    echo "Application should now be running at: http://localhost:3001"
                    bat 'docker ps'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }

        failure {
            echo '❌ Build failed! Please check the console output and logs.'
        }

        success {
            echo '✅ Build and deployment successful!'
        }
    }
}
