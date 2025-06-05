USERNAME=admin
PASSWORD=admin
JENKINS_HOST=http://localhost:8080
CERT_DIR=./registry/certs
DOMAIN=registry

.PHONY: up certs refresh destroy help

help:
	@echo "Available commands:"
	@echo "  make up       - Build and start all containers in background"
	@echo "  make certs    - Generate self-signed TLS certificates for the registry"
	@echo "  make refresh  - Fetch latest Jenkins secrets and update docker-compose.yml"
	@echo "  make destroy  - Stop and remove containers, volumes, and certificates"
	@echo "  make help     - Show this help message"

up:
	docker compose up -d --build

certs:
	mkdir -p ${CERT_DIR}
	openssl req \
	  -newkey rsa:4096 -nodes -sha256 -keyout ${CERT_DIR}/domain.key \
	  -x509 -days 365 -out ${CERT_DIR}/domain.crt \
	  -subj "/C=US/ST=State/L=City/O=Org/OU=Unit/CN=${DOMAIN}"

refresh:
	@echo "Fetching JNLP secrets from Jenkins at ${JENKINS_URL}..."
	SECRET_DEV=$$(curl -su admin:admin http://localhost:8080/computer/dev/slave-agent.jnlp | grep -oP '(?<=<argument>)[a-f0-9]{64}(?=</argument>)' | head -n 1); \
	SECRET_PROD=$$(curl -su admin:admin http://localhost:8080/computer/prod/slave-agent.jnlp | grep -oP '(?<=<argument>)[a-f0-9]{64}(?=</argument>)' | tail -n 1); \
	echo "Updating docker-compose.yml with new secrets..."; \
	sed -i "s/\(JENKINS_SECRET=\)[a-f0-9]*/\1$${SECRET_DEV}/" docker-compose.yml; \
	sed -i "/jenkins-agent-prod/,\$$s/\(JENKINS_SECRET=\)[a-f0-9]*/\1$${SECRET_PROD}/" docker-compose.yml; \
	docker compose up -d --build

destroy:
	docker compose down -v
	rm -rf ${CERT_DIR}
