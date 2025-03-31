pipeline {
    agent any

    // Este pipeline se ejecuta solo en la rama "main"
    triggers {
        pollSCM('H/15 * * * *')
    }

    environment {
        GIT_REPO = 'https://github.com/molina147893/Testing-React-Redux'
        GIT_BRANCH = 'main'
        DOCKER_IMAGE = 'my-app:latest'
        CONTAINER_NAME = 'my-app-container'
        PROJECT_PATH = '/opt/proyecto'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando el repositorio en la VM...'
                sh '''
                rm -rf ${PROJECT_PATH} || true
                git clone --branch ${GIT_BRANCH} ${GIT_REPO} ${PROJECT_PATH}
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Instalando dependencias en la VM...'
                sh '''
                cd ${PROJECT_PATH}
                npm install --legacy-peer-deps
                '''
            }
        }

        stage('Testing') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            echo 'Ejecutando tests unitarios...'
                            sh '''
                            cd ${PROJECT_PATH}
                            npm test -- --watchAll=false --ci --reporters=default --coverage
                            '''
                        }
                    }
                }

                stage('Functional Tests') {
                    steps {
                        echo 'Todavía no hay tests funcionales en esta rama'
                    }
                }

                stage('Integration Tests') {
                    steps {
                        echo 'Todavía no hay tests de integración en esta rama'
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo 'Construyendo la imagen Docker en la VM...'
                    sh '''
                    cd ${PROJECT_PATH}
                    docker build -t ${DOCKER_IMAGE} .
                    '''
                }
            }
        }

        stage('Deploy en contenedor de la asignatura (VM)') {
            steps {
                script {
                    echo 'Actualizando el código en la VM...'
                    sh '''
                    cd ${PROJECT_PATH}
                    git pull origin main
                    npm install --legacy-peer-deps
                    export CI=false
                    npm run build
                    '''
                }
            }
        }

        stage('Deploy en Docker dentro de la VM') {
            steps {
                script {
                    echo 'Desplegando la imagen en un contenedor Docker dentro de la VM...'
                    sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 80:80 ${DOCKER_IMAGE}
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline ejecutado con éxito o fallido'
        }
        success {
            echo 'Pipeline completado con éxito'
        }
        failure {
            echo 'Pipeline fallido'
        }
    }
}
