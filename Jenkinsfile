pipeline {
    agent {
        node {
             label 'maven' 
        }
    }

environment {
    PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
}

    stages {
        stage("build") {
            steps {
                sh 'mvn clean deploy'
            }
        }
        
        stage("sonar-scan") {
            environment {
                scannerHome = 'my-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('my-sonarqube-server')
                sh "${scannerHome}/bin/my-sonar-scanner"
            }
        }
    }
 }
