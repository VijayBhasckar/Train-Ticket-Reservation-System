pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'Docker' // Replace with your Jenkins DockerHub credentials ID
        IMAGE_NAME = 'satyasaia99/trainticket'
    }

    stages {
        stage('Checkout') {
            steps {
               git branch: 'master', url: 'https://github.com/SatyasaiA99/Train-Ticket-Reservation-System.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    '''
                }
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker stop trainticket || true
                    docker rm trainticket|| true
                    docker run -d -p 7878:8080 --name trainticket ${IMAGE_NAME}:latest
                '''
            }
        }
    }
}
