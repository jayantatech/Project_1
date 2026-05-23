pipeline {
    agent any

    environment {
        DOCKER_USERNAME = "jaybiswas"
        EC2_IP = "52.55.68.230"
        DOCKER_IMAGE = "${DOCKER_USERNAME}/project_1"
        CONTAINER_NAME = "project_1"

    }

    stages {
        stage ("Checkout Code") {
            steps {
            echo "Pulling latest code form github"
            checkout scm 
            echo "code pulling successfully"
            }
        }

        stage ("build docker image") {
            steps {
                echo "build docker image"
                sh "docker buildx build --platform linux/amd64 -t ${DOCKER_IMAGE} ."
            }
        }

        stage ("push to docker hub") {
            steps {
                echo "pushing to docker hub"
                script {
                   docker.withRegistry("", "docker-hub") {
                    // docker.image(CONTAINER_NAME).tag("${DOCKER_IMAGE}:latest")
                    // docker.image("${DOCKER_IMAGE}:latest").push()
                    sh "docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE}:latest" 
                    sh "docker push ${DOCKER_IMAGE}:latest"
                   }
                }
            }
        }

        stage ("deploy code to ec2") {
            steps {
                echo "ec2 deploy stage"
                sshagent(['ec2-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                            docker pull ${DOCKER_IMAGE}:latest &&
                            (docker stop ${CONTAINER_NAME} || true) &&
                            (docker rm ${CONTAINER_NAME} || true) &&
                            docker run -d --name ${CONTAINER_NAME} -p 3000:80 --restart always ${DOCKER_IMAGE}:latest
                        '
                    """
                }
            }
        }
    }
}