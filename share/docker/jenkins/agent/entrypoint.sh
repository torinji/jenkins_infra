#!/bin/bash

# Wait until Jenkins is available
until curl -s "$JENKINS_URL/login" > /dev/null; do
  echo "Waiting for Jenkins at $JENKINS_URL..."
  sleep 5
done

# Start the agent
exec /usr/bin/java -jar /usr/share/jenkins/agent.jar \
  -jnlpUrl "$JENKINS_URL/computer/$JENKINS_AGENT_NAME/jenkins-agent.jnlp" \
  -secret "$JENKINS_SECRET" \
  -workDir "$JENKINS_AGENT_WORKDIR"
