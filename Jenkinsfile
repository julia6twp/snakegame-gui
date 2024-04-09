pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/julia6twp/snakegame-gui'
            }
        }

        stage('Build') {
            steps {
                sh 'docker-compose up --build'
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