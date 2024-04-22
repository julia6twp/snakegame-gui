pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Collect') {
            steps {
                sh "mkdir -p log"
                sh "docker container prune -f"
                sh "docker image prune -af"
            }
        }
        
        stage('Checkout') {
            steps {
                git 'https://github.com/julia6twp/snakegame-gui'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t pysnake .'
                sh 'docker run --name pysnake pysnake'
                sh 'docker logs pysnake > ./log/pysnake_log.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'docker build -t pysnake-test ./docker_'
                sh 'docker run --name pysnake-test pysnake-test'
                sh 'docker logs pysnake-test > ./log/pysnake_deploy_log.txt'
            }
        }
        stage('Deploy'){
            steps {
                sh 'docker build -t pysnake-deploy ./deploy'
                sh 'docker run --name pysnake-deploy pysnake-deploy'
                sh 'docker logs pysnake-deploy > ./log/pysnake_test_log.txt'
            }
        }
        stage('Publish'){
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker tag pysnake-deploy $DOCKER_USERNAME/pysnake-deploy:latest'
                    sh 'docker push $DOCKER_USERNAME/pysnake-deploy:latest'
                }
            }
        }
    }

    post {
        success {
            echo 'Budowa zakończona sukcesem! Możesz wykonać dodatkowe akcje tutaj.'
        }
        failure {
            echo 'Budowa nie powiodła się. Sprawdź logi i popraw błędy.'
        }
    }
}
