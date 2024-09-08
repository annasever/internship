pipeline {
    agent {
        label 'internship_project'
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        POSTGRES_DB           = credentials('mydatabase')
        POSTGRES_USER         = credentials('myuser')
        POSTGRES_PASSWORD     = credentials('mypassword')
        MONGO_INITDB_DATABASE = credentials('my_mongo_database')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        BACKEND_IMAGE = 'annasever/backend'
        FRONTEND_IMAGE = 'annasever/frontend'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkins-git-user', url: 'git@github.com:annasever/internship_project.git']])
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                dir('backend') {
                    script {
                        sh 'sudo docker build -t $BACKEND_IMAGE .'
                    }
                }
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                dir('frontend') {
                    script {
                        sh 'sudo docker build -t $FRONTEND_IMAGE .'
                    }
                }
            }
        }

        stage('Push Docker Images to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                        sh 'sudo docker push $BACKEND_IMAGE'
                        sh 'sudo docker push $FRONTEND_IMAGE'
                    }
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    sh 'sudo docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'sudo docker-compose down'
            }
        }
    }
}

