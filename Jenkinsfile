pipeline {
    environment { 
        containerRegistry = "your_dockerhub_registry_username/repository" 
        containerRegistryCredential = 'your-jenkins-global-dockerhub-credential-id'
        dockerPullLogin = 'your_dockerhub_registry_username'
        dockerPullAccessToken = 'your-dockerhub-registry-access-token'
        dockerLatestImage = ''
        dockerVerTagImage = ''
        versionTag = ''
        sshServer = 'ssh-username@server-ip-address'
    }
    agent any
    stages {
        stage('Clone') {
            steps {
                sh "echo 'cloning the source code...'"
                git credentialsId: 'your-jenkins-global-git-credential-id', url: 'https://github.com/your-sample-git-repository.git'
                // take last version tag of the git repository
                script { 
                    versionTag = sh(script: "git describe --tags `git rev-list --tags --max-count=1`", returnStdout: true).trim()
                }
            }  
        }
        stage('Build') { 
            steps { 
                sh "echo 'build & tag latest and version images...'"
                script {
                    // build 2 images. One with :latest tag and another with :{VERSION_NUMBER}
                    dockerLatestImage = docker.build "$containerRegistry:latest"
                    dockerVerTagImage = docker.build "$containerRegistry:$versionTag"
                }
            } 
        }
        stage('Publish') { 
            steps { 
                sh "echo 'pushing to container registry...'"
                script { 
                    // push both images to container registry
                    docker.withRegistry( '', containerRegistryCredential ) { 
                        dockerLatestImage.push() 
                        dockerVerTagImage.push() 
                    }
                }
            } 
        }
        stage('Deploy') { 
            steps { 
                sh "echo 'deploying to production...'"
                 sshagent(['your-jenkins-global-ssh-credential-id']) {
                    // login to server using SSH
                    sh 'ssh -o StrictHostKeyChecking=no $sshServer uptime'
                    sh 'ssh -v $sshServer'
                    // verify docker hub access login to pull images
                    sh 'ssh $sshServer "docker login -u $dockerPullLogin -p $dockerPullAccessToken"'
                    // pull latest image
                    sh 'ssh $sshServer "docker pull your_dockerhub_registry_username/mywebsite:latest"'
                    // up the pulled docker image
                    sh 'ssh $sshServer "cd /var/www/mywebsite && bash && docker-compose up -d"'
                }
            } 
        }
        stage('Clean') { 
            // cleaning workspace
            steps { 
                sh "echo 'cleaning the workspace...'"
                sh "docker rmi $containerRegistry:latest"
                sh "docker rmi $containerRegistry:$versionTag"
            }
        } 
    }
}