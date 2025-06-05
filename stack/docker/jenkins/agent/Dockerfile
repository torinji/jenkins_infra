FROM jenkins/inbound-agent:latest

USER root

ARG DOCKER_GID=998

RUN groupadd -g ${DOCKER_GID} docker && usermod -aG docker jenkins

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io python3 python3-pip git && \
    apt-get clean

# Add certs for registry
RUN mkdir -p /etc/docker/certs.d/registry:5000
COPY registry/certs/domain.crt /etc/docker/certs.d/registry:5000/ca.crt
RUN update-ca-certificates && rm -rf /var/lib/apt/lists/*

USER jenkins
