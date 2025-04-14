pipeline {
    agent any

    environment {
        DOCKER_HUB = credentials('dockerhub-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sruthi-3-0/cddproject.git'
            }
        }

        stage('Build') {
            steps {
                bat 'docker build -t sruthi-cddproject:latest .'
            }
        }

        stage('Test') {
            steps {
                script {
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {

                        // Kill any process on port 3000
                        bat '''
@echo off
echo Checking for process using port 3000...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000') do (
    echo Found process on port 3000 - PID: %%a
    taskkill /PID %%a /F
)
exit /b 0
'''

                        // Clean up any existing test container
                        bat 'docker rm -f test-container || echo "No existing container to remove"'

                        // Start test container
                        bat 'docker run -d --name test-container -p 3000:80 sruthi-cddproject:latest'

                        // Wait for container to start
                        sleep(time: 15, unit: 'SECONDS')

                        // Health check with retries
                        bat '''
@echo off
set RETRIES=5
set WAIT=5
echo Running health check on http://localhost:3000 ...
:retry
curl -f http://localhost:3000
if %ERRORLEVEL% EQU 0 (
    echo Health check passed
    goto success
) else (
    echo Health check failed, retrying in %WAIT% seconds...
    timeout /T %WAIT% >nul
    set /A RETRIES=%RETRIES%-1
    if %RETRIES% GTR 0 goto retry
)

:fail
echo Health check failed after retries
exit /b 1

:success
exit /b 0
'''
                    }
                }
            }

            post {
                always {
                    bat '''
@echo off
docker logs test-container || echo "No logs found"
docker stop test-container || echo "Stop failed"
docker rm test-container || echo "Remove failed"
'''
                }
            }
        }

        stage('Deploy') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                bat 'docker tag sruthi-cddproject:latest %DOCKER_HUB_USR%/sruthi-cddproject:latest'
                bat 'docker login -u %DOCKER_HUB_USR% -p %DOCKER_HUB_PSW%'
                bat 'docker push %DOCKER_HUB_USR%/sruthi-cddproject:latest'
            }
        }
    }
}
