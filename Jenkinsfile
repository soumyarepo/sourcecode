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
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                script{
                    // Your SonarQube analysis steps here
                    withSonarQubeEnv('sonarqube-server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
    }
 }
