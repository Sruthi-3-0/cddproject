pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials') // Jenkins credentials ID for DockerHub
        IMAGE_NAME = 'sruthikanneti/cddproject'
        IMAGE_TAG = "${BUILD_NUMBER}" // Auto-incremented Jenkins build number
    }

    stages {

        stage('Debug: Environment Info') {
            steps {
                echo "Jenkins Build Number: ${env.BUILD_NUMBER}"
                echo "Docker Image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                bat 'docker --version'
                bat 'echo Current directory is: %CD%'
            }
        }

        stage('Clone Repository') {
            steps {
                echo "Cloning repository..."
                git branch: 'main', url: 'https://github.com/Sruthi-3-0/cddproject.git'
                bat 'dir' // Debug: List files
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                script {
                    docker.build("${env.IMAGE_NAME}:${env.IMAGE_TAG}")
                }
                bat "docker images" // Debug: Show Docker images
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${env.IMAGE_NAME}:${env.IMAGE_TAG}").push()
                    }
                }
                bat "docker images" // Debug: Confirm image pushed
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    def image = "${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                    echo "Deploying Docker container using image: ${image}"

                    // Stop any existing container with the same image
                    bat """
                        echo Checking for running containers from image: ${image}
                        for /f "tokens=*" %%i in ('docker ps -q --filter "ancestor=${image}"') do docker stop %%i
                    """

                    // Run new container
                    bat "docker run -d -p 3001:80 ${image}"

                    // Debug: Show running containers
                    bat "docker ps"

                    echo "✅ Application is now running at: http://localhost:3001"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
        failure {
            echo "❌ Build failed! Please check the console output and logs."
        }
        success {
            echo "🎉 Build completed successfully!"
        }
    }
}
