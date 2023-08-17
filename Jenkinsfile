registry = 'https://ubstech.jfrog.io/'
pipeline {
    agent {
        node {
             label 'maven' 
        }
    }

environment {
    PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
    // Artifactory details
    //registry = 'https://ubstech.jfrog.io/'
     //artifactory = 'ubs-libs-release'
     //artifactory_token = 'artifact-cred'
     //Artifact location = '/home/ubuntu/jenkins/workspace/multibranchpipeline_main/jarstaging/com/valaxy/demo-workshop'
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
        
        /*stage("sonar-scan") {
            steps {
                script{
                    def scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withSonarQubeEnv('sonarqube-server') {
                        sh "${scannerHome}/bin/sonar-scanner -X"
                    }
                }
            }
        }*/

        stage("Artifactory Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifact-cred"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "libs-release-local/{1}",
                                "flat": false,
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Artifactory Publish Ended --------------->'
                }
            }
        }
    }
 }
