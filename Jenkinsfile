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
    }
    stage("SonarQube") {
    environment {
        scannerHome = tool 'my-sonar-scanner'
    }
    steps {
    sca
    script {
        withSonarQubeEnv('my-sonarqube-server') {
        // Run SonarQube scanner to analyze the code
            sh "${scannerHome}/bin/my-sonar-scanner"
            }
        }
    }
}

}