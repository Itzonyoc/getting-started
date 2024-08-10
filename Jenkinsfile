pipeline {
    agent any

    environment {
        VERSION_TAG = "3.0.0"
        IMAGE_NAME = "getting-started"
        DOCKER_HUB_REGISTRY = credentials('registro-hub')
    }
 
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
        stage('SonarQube') {
            environment {
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                withSonarQubeEnv(credentialsId: 'SonarQubeClase04', installationName: 'sonarqube'){
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
 
        }
        /*stage('Build') {
            steps {
                echo 'Compilando el código...'
                sh "docker build -t $DOCKER_HUB_REGISTRY/$IMAGE_NAME:$VERSION_TAG ."
            }
        }
        stage('Pruebas') {
            steps {
                echo 'Ejecutando pruebas...'
            }
        }
        stage('Trivy-Scan') {
            agent {
                docker {
                    image 'aquasec/trivy:0.48.1'
                    args '--entrypoint="" -u root -v /var/run/docker.sock:/var/run/docker.sock -v ${WORKSPACE}:/src'
                }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        sh "trivy image --format json --output report_trivy.json $DOCKER_HUB_REGISTRY/$IMAGE_NAME:$VERSION_TAG"
                        archiveArtifacts artifacts: "report_trivy.json"
                    }
                }
            }
        }*/ //No se va a ocupar porque vamos a publicar hacia Azure
        stage('Despliegue') {
            agent {
                docker {
                    image 'jenkins-ansible:1.0.0'
                    args '--entrypoint="" -u root'
                }
            }
            steps {
                echo 'Desplegando la aplicación...'
                script {
                    withCredentials([azureServicePrincipal('sp-azure-curso-devops')]) {
                        echo "Iniciando sesión Azure"

                        sh "az account clear"
                        sh "az login --service-principal --username ${AZURE_CLIENT_ID} --password ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}"
                        sh "az account set --subscription ${AZURE_SUBSCRIPTION_ID}"
                        // Se omite esta línea porque se hará una publicación al AppService
                        // sh "ansible-playbook main.yml -i hosts -e TIPO_TAREA=" + env.TIPO + " -e subscription_id=${AZURE_SUBSCRIPTION_ID} -e client_id=${AZURE_CLIENT_ID} -e secret_id=${AZURE_CLIENT_SECRET} -e tenant_id=${AZURE_TENANT_ID} -v"

                        // Comando para obtener las modalidades de publicacion
                        // az webapp deployment list-publishing-profiles --resource-group myResourceGroupAppNode2 --name myfirstWebAppNodeAnsible-JFF
                        // myfirstwebappnodeansible-jff.scm.azurewebsites.net:443

                        withCredentials([usernamePassword(
                            credentialsId: "username-azure-app-service-deploy",
                            usernameVariable: "username_webapp",
                            passwordVariable: "password_webapp"
                        )]) {

                            sh 'git init'
                            sh 'git config --local user.email "myapp@mail.com"'
                            sh 'git config --local user.name "myapp"'
                            sh 'git add *'
                            sh 'git commit -m "Initial commit"'
                            sh 'git checkout -b master'
                            sh "git remote add azure https://\\${username_webapp}:${password_webapp}@myfirstwebappnodeansible-jff.scm.azurewebsites.net:443/myfirstwebappnodeansible-jff.git"
                            sh 'git push -u azure master -f'

                        }
                    }
                }
            }
        }
        stage ('post-despliegue') {
            steps {
                cleanWs()
            }
        }
    }
}