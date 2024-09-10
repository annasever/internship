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
        GITHUB_WEBHOOK_SECRET = credentials('webhook_secret_credentials')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkins-git-user', url: 'git@github.com:annasever/jenkins_project.git']])
            }
        }

        stage('Build Frontend Image') {
            steps {
                script {
                    dir('frontend') {
                        def frontendImage = docker.build("${DOCKERHUB_REPO}-frontend:${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                script {
                    def backendImage = docker.build("${DOCKERHUB_REPO}-backend:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.image("${DOCKERHUB_REPO}-frontend:${env.BUILD_NUMBER}").push("${env.BUILD_NUMBER}")
                    docker.image("${DOCKERHUB_REPO}-frontend:latest").push("latest")

                    docker.image("${DOCKERHUB_REPO}-backend:${env.BUILD_NUMBER}").push("${env.BUILD_NUMBER}")
                    docker.image("${DOCKERHUB_REPO}-backend:latest").push("latest")
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    withEnv([
                        "POSTGRES_DB=${POSTGRES_DB}",
                        "POSTGRES_USER=${POSTGRES_USER}",
                        "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}",
                        "MONGO_INITDB_DATABASE=${MONGO_INITDB_DATABASE}"
                    ]) {
                        sh 'docker-compose up -d'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build, push, and deployment completed successfully, shutting down containers...'
            script {
                sh 'docker-compose down'
            }
        }

        failure {
            echo 'Build, push, or deployment failed!'
        }
    }
}

