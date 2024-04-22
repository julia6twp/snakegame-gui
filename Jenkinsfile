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
                sh 'docker build -t snakepy .'
                sh 'docker run --name snakepy snakepy'
                sh 'docker logs snakepy > ./log/snakepy_log.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'docker build -t snakepy-test ./docker_'
                sh 'docker run --name snakepy-test snakepy-test'
                sh 'docker logs snakepy-test > ./log/snakepy_deploy_log.txt'
            }
        }
        stage('Deploy'){
            steps {
                sh 'docker build -t snakepy-deploy ./docker_'
                sh 'docker run --name snakepy-deploy snakepy-deploy'
                sh 'docker logs snakepy-deploy > ./log/snakepy_test_log.txt'
            }
        }
        stage('Publish'){
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker tag snakepy-deploy $DOCKER_USERNAME/snakepy-deploy:latest'
                    sh 'docker push $DOCKER_USERNAME/snakepy-deploy:latest'
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
