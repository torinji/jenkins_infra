FROM jenkins/jenkins:lts

ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs

RUN mkdir -p /var/jenkins_home \
    && chown -R 1000:1000 /var/jenkins_home \
    && chmod -R 775 /var/jenkins_home

# Install plugins
RUN jenkins-plugin-cli --plugins \
    configuration-as-code \
    prometheus \
    workflow-aggregator \
    git

# Copy configuration files
COPY jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
COPY jobscripts/ /var/jenkins_home/jobscripts/
