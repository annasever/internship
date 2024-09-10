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
        BUILD_VERSION = "${env.BUILD_NUMBER}" // Общая версия для фронтенда и бекенда
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

        stage('Build Backend Image') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        dir('backend') {
                            def backendImage = docker.build("${DOCKERHUB_REPO}-backend:${BUILD_VERSION}")
                            backendImage.tag("${DOCKERHUB_REPO}-backend:latest")
                        }
                    }
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        dir('frontend') {
                            def frontendImage = docker.build("${DOCKERHUB_REPO}-frontend:${BUILD_VERSION}")
                            frontendImage.tag("${DOCKERHUB_REPO}-frontend:latest")
                        }
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    if (currentBuild.resultIsBetterOrEqualTo('SUCCESS')) {
                        echo "Pushing images to DockerHub with version ${BUILD_VERSION}"

                        docker.image("${DOCKERHUB_REPO}-backend:${BUILD_VERSION}").push("${BUILD_VERSION}")
                        docker.image("${DOCKERHUB_REPO}-backend:latest").push("latest")

                        docker.image("${DOCKERHUB_REPO}-frontend:${BUILD_VERSION}").push("${BUILD_VERSION}")
                        docker.image("${DOCKERHUB_REPO}-frontend:latest").push("latest")
                    } else {
                        echo "Skipping push as one or more builds failed"
                    }
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

