pipeline {
    agent any
    
    // Este pipeline se ejecuta solo en la rama "1-feature"
    triggers {
        githubPush()  // O se puede usar un webhook para detectar cambios en el repositorio
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Instalando dependencias...'
                // Usamos npm install con la opción --legacy-peer-deps si hay problemas de dependencias.
                sh 'npm install --legacy-peer-deps'
            }
        }
        
        stage('Testing') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            echo 'Ejecutando tests unitarios...'
                            // Aquí se ejecutan los tests unitarios de la aplicación.
                            sh 'npm test -- --watchAll=false --ci --reporters=default --coverage'
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
    }
}
