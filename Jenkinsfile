pipeline {
    agent any
    tools {
        maven 'mvn_v3.9.0'
    }
    stages {
        stage ("Sonar Cloud Analysis - SAST") {
            environment {
                SONAR_CREDENTIALS = credentials('sonar_credentials')
            }
            steps {
                sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR_CREDENTIALS_PSW -Dsonar.host.url=https://sonarcloud.io \
                                                 -Dsonar.organization=easybuggyapplication -Dsonar.projectKey=$SONAR_CREDENTIALS_USR'
            }
        }
        stage ("Snyk Analysis - SCA") {
            steps {
                snykSecurity(
                    failOnIssues: false,
                    organisation: 'subrahmanyamraparti',
                    projectName: 'EasyBuggyApplication',
                    snykInstallation: 'snyk_latest',
                    snykTokenId: 'snyk-api'
                )
            }
        }
        stage ("Build & Verify") {
            steps {
                sh 'mvn -B clean verify'  // Lifecycles: validate, compile, test, package, verify
            }
        }
        stage ("Build Docker Image") {
            environment {
                DOCKER_TAG = committag()
            }
            steps {
                sh 'docker build -t easybuggyapplication:$DOCKER_TAG .'
                sh 'docker tag -t easybuggyapplication:$DOCKER_TAG easybuggyapplication:latest'
            }
        }
    }
}

def committag() {
    def tag = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return tag
}