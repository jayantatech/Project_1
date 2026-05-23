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
                echo "Building and pushing docker image"
                script {
                    docker.withRegistry("", "docker-hub") {
                        sh """
                            docker buildx build \
                                --platform linux/amd64 \
                                --push \
                                --no-cache \
                                -t ${DOCKER_IMAGE}:latest .
                        """
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
                            docker run -d --name ${CONTAINER_NAME} -p 80:80 --restart always ${DOCKER_IMAGE}:latest
                        '
                    """
                }
            }
        }
    }
}