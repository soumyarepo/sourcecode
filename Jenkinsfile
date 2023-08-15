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

        stage("unit-test") {
            steps {
                echo"-----------unit test started--------"
                sh 'mvn surefire-report:report'
                echo"-----------unit test finished--------"

            }
        }
        
        stage("sonar-scan") {
            steps {
                script{
                    def scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withSonarQubeEnv('sonarqube-server') {
                        sh "${scannerHome}/bin/sonar-scanner -X"
                    }
                }
            }
        }
    }
 }
