pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/yourappname"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/yourusername/yourrepository.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USER} --password-stdin"
                    }
                    sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    sh 'docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}'
                    sh 'docker run -d -p 8080:8080 ${DOCKER_IMAGE}:${DOCKER_TAG}'
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean up workspace after the build
        }
    }
}
