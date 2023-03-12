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
    stages {
        stage ("Synk Analysis - SCA") {
            snykSecurity(
                organization: 'SubrahmanyamRaparti',
                projectName: 'EasyBuggyApplication',
                snykInstallation: 'snyk_latest',
                snykTokenId: 'snyk-api'
            )
        }
    }
}