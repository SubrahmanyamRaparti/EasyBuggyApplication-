pipeline {
    agent any
    tools {
        maven 'mvn_v3.9.0'
    }
    environment {
        AWS_REGION = getregion()
        AWS_ACCOUNT_ID = getaccount()
        DOCKER_TAG = committag()
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
            steps {
                sh 'docker build --compress -t easybuggyapplication:latest .'
                sh 'docker tag easybuggyapplication:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/easybuggyapplication:latest'
                sh 'docker tag easybuggyapplication:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/easybuggyapplication:$DOCKER_TAG'
            }
        }
        stage ("Push Docker Image to AWS ECR") {
            steps {
                sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com'
                sh 'docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/easybuggyapplication:latest'
                sh 'docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/easybuggyapplication:$DOCKER_TAG'
            }
        }
    }
}

def committag() {
    def tag = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return tag
}

def getregion() {
    def region = sh returnStdout: true, script: 'curl -s  http://169.254.169.254/latest/meta-data/placement/region'
    return region
}

def getaccount() {
    def account = sh returnStdout: true, script: 'aws sts get-caller-identity | jq ".Account" -r'
    return account.replaceAll("\\s","")
}