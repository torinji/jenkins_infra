pipeline {
  agent { label params.AGENT_LABEL }

  parameters {
    string(name: 'AGENT_LABEL', defaultValue: 'prod', description: 'Label of the agent to run on')
    string(name: 'DOCKER_REGISTRY', defaultValue: 'registry:5000', description: 'Docker Registry host and port')
    string(name: 'IMAGE_NAME', defaultValue: 'simple-web', description: 'Docker image name')
    string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag')
    string(name: 'CONTAINER_NAME', defaultValue: 'simple-web-prod', description: 'Docker container name')
    string(name: 'APP_PORT', defaultValue: '8000', description: 'App port to expose')
    string(name: 'DOMAIN', defaultValue: 'prod.local', description: 'Domain for health check (no port)')
  }

  environment {
    FULL_IMAGE = "${params.DOCKER_REGISTRY}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
  }

  stages {
    stage('Pull Latest Image') {
      steps {
        script {
          echo "Pulling latest image: ${FULL_IMAGE}"
          sh "docker pull ${FULL_IMAGE}"
        }
      }
    }

    stage('Stop Old Container') {
      steps {
        script {
          echo "Stopping and removing old container if it exists..."
          sh """
            docker ps -q --filter name=${params.CONTAINER_NAME} | xargs -r docker rm -f || true
          """
        }
      }
    }

    stage('Run New Container') {
      steps {
        script {
          echo "Running new container: ${params.CONTAINER_NAME}"
          sh """
            docker run -d \
              --name ${params.CONTAINER_NAME} \
              -p ${params.APP_PORT}:${params.APP_PORT} \
              ${FULL_IMAGE}
          """
        }
      }
    }

    stage('Health Check') {
      steps {
        script {
          def success = false
          for (int i = 0; i < 5; i++) {
            sleep 5
            def result = sh(script: "curl -s -o /dev/null -w \"%{http_code}\" http://${params.DOMAIN}:${params.APP_PORT}/health", returnStdout: true).trim()
            if (result == "200") {
              echo "Health check passed"
              success = true
              break
            } else {
              echo "Attempt ${i + 1}/5 failed: HTTP ${result}"
            }
          }
          if (!success) {
            error("Health check failed after 5 attempts.")
          }
        }
      }
    }
  }

  post {
    success {
      echo "Deployment successful. Container '${params.CONTAINER_NAME}' is running."
    }
    failure {
      echo "Deployment failed."
    }
  }
}
