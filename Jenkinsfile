pipeline {
    agent any
 
    stages {
        stage('Gitleaks-Scan') {

            agent {

                docker {

                    image 'zricethezav/gitleaks'

                    args '--entrypoint="" -u root -v ${WORKSPACE}:/src'

                }

            }                    

            steps {

                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {

                    script {

                        sh "gitleaks detect --verbose --source . -f json -r report_gitleaks.json"

                        sh "ls -la"

                        archiveArtifacts artifacts: "report_gitleaks.json"

                        //stash includes: 'report_gitleaks.json', name: 'report_gitleaks.json'

                    }

                }

            }

        }
        stage('Build') {
            steps {
                echo 'Compilando el código...'
            }
        }
        stage('SonarQube') {
            environment {
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                withSonarQubeEnv(credentialsId: 'sonar-token', installationName: 'sonarqube'){
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
 
        }
        stage('Pruebas') {
            steps {
                echo 'Ejecutando pruebas...'
            }
        }
 
        stage('Despliegue') {
            steps {
                echo 'Desplegando la aplicación...'
            }
        }
    }
}