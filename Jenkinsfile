def registry = 'https://ubstech.jfrog.io/'
def imageName = 'ubstech.jfrog.io/dev-docker-local/dummy'
def version   = '2.1.2'
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
        

        stage("Artifactory Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifactory-cred"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "ubs-libs-release-local/{1}",
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

        stage(" Docker Build ") {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build(imageName+":"+version)
                    echo '<--------------- Docker Build Ends --------------->'
                 }
            }
        }

        stage (" Docker Promote ") {
           steps {
                script {
                   echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry(registry, 'artifactory-cred'){
                        app.push()
                    }  
                   echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }

        stage (" Deployment") {
           steps {
                script {
                   echo '<--------------- Deployment Started --------------->'
                    sh 'chmod +x deploy.sh'
                    sh './deploy.sh'
                    echo '<--------------- Deployment completed --------------->'
                    }
                   
                }
            }
        }

    post {
        always {
            // Send email notification on pipeline completion, regardless of success or failure
            emailext(
            to: 'ranjan.soumya8055@gmail.com' , // Add other recipients here as needed
            subject: "Pipeline ${currentBuild.result}: Deployment Status",
            body: "Pipeline ${currentBuild.result}: Your application Deployment has completed.\n\n${BUILD_URL}",
            recipientProviders: [[$class: 'CulpritsRecipientProvider']],
            )
        }
    }
}