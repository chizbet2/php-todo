pipeline{
    agent any

    environment {
        TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        max = 20
        random_num = "${Math.abs(new Random().nextInt(max+1))}"
//         docker_password = credentials('dockerhub_password')
    }
       stages{
        stage("Workspace Cleanup") {
            steps {
                dir("${WORKSPACE}") {
                    deleteDir()
                }
            }
        }

        stage('Checkout Git') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/chizbet2/php-todo.git']])
        }
        }
        stage('Building app') {
            steps {
                script {
                    
                    sh " docker login -u iykeuzoho -p ${env.PASSWORD}"
                    sh " docker build -t iykeuzoho/php-todo-proj20:${env.TAG} ."
                }
            }
        }
        stage('Creating docker container') {
            steps {
                script {
                    sh " docker run -d --name=todo-app-${env.random_num} -p 8000:8000 iykeuzoho/php-todo-proj20:${env.TAG}"
                }
            }
        }
         stage("Smoke Test") {
            steps {
                script {
                    sh "sleep 60"
                    sh "curl -I 54.167.99.240:8000"
                }
            }
        }

        stage("Publish to Registry") {
            steps {
                script {
                    sh " docker push iykeuzoho/php-todo-proj20:${env.TAG}"
                }
            }
        }
        stage ('Clean Up') {
            steps {
                script {
                    sh " docker stop todo-app-${env.random_num}"
                    sh " docker rm todo-app-${env.random_num}"
                    sh " docker rmi iykeuzoho/php-todo-proj20:${env.TAG}"
                }
            }
        }

        stage ('logout Docker') {
            steps {
                script {
                    sh " docker logout"
                }
            }
        }
    }
   
}