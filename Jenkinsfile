@Library('Shared') _
pipeline {
    agent {label 'Node'}
    
    environment{
        SONAR_HOME = tool "Sonar"
        // Auto-incrementing semver-style tag: MAJOR.MINOR fixed, PATCH follows Jenkins' BUILD_NUMBER.
        // Bump the "1.0" prefix by hand here if you ever want a real major/minor release.
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
    }

    stages {
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
            }
        }
        
        stage('Git: Code Checkout') {
            steps {
                script{
                    code_checkout("https://github.com/tanaylonkar6993/wanderlust-azure.git","main")
                }
            }
        }
        
        stage("Trivy: Filesystem scan"){
            steps{
                script{
                    trivy_scan()
                }
            }
        }

        stage("OWASP: Dependency check"){
            steps{
                script{
                    owasp_dependency()
                }
            }
        }
        
        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarqube_analysis("Sonar","wanderlust","wanderlust")
                }
            }
        }
        
        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarqube_code_quality()
                }
            }
        }
        
        stage('Exporting environment variables') {
            parallel{
                stage("Backend env setup"){
                    steps {
                        script{
                            dir("Automations"){
                                sh "bash updatebackendnew.sh"
                            }
                        }
                    }
                }
                
                stage("Frontend env setup"){
                    steps {
                        script{
                            dir("Automations"){
                                sh "bash updatefrontendnew.sh"
                            }
                        }
                    }
                }
            }
        }
        
        stage("Docker: Build Images"){
            steps{
                script{
                        dir('backend'){
                            docker_build("wanderlust-backend-beta","${IMAGE_TAG}","tanaylonkar")
                        }

                        dir('frontend'){
                            docker_build("wanderlust-frontend-beta","${IMAGE_TAG}","tanaylonkar")
                        }
                }
            }
        }
        
        stage("Docker: Push to DockerHub"){
            steps{
                script{
                    docker_push("wanderlust-backend-beta","${IMAGE_TAG}","tanaylonkar")
                    docker_push("wanderlust-frontend-beta","${IMAGE_TAG}","tanaylonkar")
                }
            }
        }
    }
    post{
        success{
            archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "Wanderlust-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${IMAGE_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${IMAGE_TAG}")
            ]
        }
    }
}
