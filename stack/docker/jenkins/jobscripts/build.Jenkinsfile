pipeline {
  agent { label params.AGENT_LABEL ?: 'dev' }

  parameters {
    string(name: 'AGENT_LABEL', defaultValue: 'dev', description: 'Jenkins agent label')
    string(name: 'GIT_REPO', defaultValue: 'https://github.com/torinji/simple-web.git', description: 'Git repository URL')
    string(name: 'BRANCH', defaultValue: 'main', description: 'Git branch to build')
    string(name: 'APP_PORT', defaultValue: '8001', description: 'App port to expose')
    string(name: 'DOMAIN', defaultValue: 'dev.local', description: 'Domain for health check (without port)')
    string(name: 'DOCKER_REGISTRY', defaultValue: 'registry:5000', description: 'Docker registry URL')
    string(name: 'IMAGE_NAME', defaultValue: 'simple-web', description: 'Docker image name')
    string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag')
  }

  stages {
    stage('Checkout') {
      steps {
        git url: "${params.GIT_REPO}", branch: "${params.BRANCH}"
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${params.IMAGE_NAME}:${params.IMAGE_TAG} ."
        }
      }
    }

    stage('Run container') {
      steps {
        script {
          sh """
            docker ps --filter "name=${params.IMAGE_NAME}" --format "{{.ID}}" | xargs -r docker stop
            
            docker run -d --rm \
              --name ${params.IMAGE_NAME} \
              -e APP_PORT=${params.APP_PORT} \
              -p ${params.APP_PORT}:${params.APP_PORT} \
              ${params.IMAGE_NAME}:${params.IMAGE_TAG}
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
            def result = sh(script: "curl -s -o /dev/null -w \"%{http_code}\" http://${params.DOMAIN}/health", returnStdout: true).trim()
            if (result == "200") {
              success = true
              echo "Health check passed"
              break
            } else {
              echo "Attempt ${i + 1}/5 failed: HTTP ${result}"
            }
          }

          if (!success) {
            sh "docker stop ${params.IMAGE_NAME}"
            error("Health check failed after 5 attempts.")
          }

          sh "docker stop ${params.IMAGE_NAME}"
        }
      }
    }

    stage('Tag & Push to Registry') {
      when {
        expression { return params.DOCKER_REGISTRY?.trim() }
      }
      steps {
        script {
          def fullImage = "${params.DOCKER_REGISTRY}/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
          sh "docker tag ${params.IMAGE_NAME}:${params.IMAGE_TAG} ${fullImage}"
          sh "docker push ${fullImage}"
        }
      }
    }
  }

  post {
    always {
      sh "docker ps -aq --filter name=${params.IMAGE_NAME} | xargs -r docker rm -f"
    }
  }
}
