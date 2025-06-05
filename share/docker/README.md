# Jenkins CI/CD Platform with Monitoring and Private Registry

## About the Project

This project provides a fully isolated local CI/CD infrastructure using **Jenkins**, **Prometheus**, **Grafana**, and a **private Docker Registry**. It is designed for local development, testing, deployment, and monitoring.

Key features include:

- CI/CD pipelines via Jenkins.
- Jenkins agents for `dev` and `prod` environments.
- Local private Docker registry secured with TLS.
- Real-time resource monitoring (CPU, memory) of agents and Jenkins using Prometheus and Grafana.
- Dashboards and alerting rules for proactive issue detection.
- One-command setup using `Makefile`.

---

## Architecture Overview

- `jenkins`: Jenkins master server.
- `jenkins-agent-dev` / `jenkins-agent-prod`: Dedicated build agents with node-exporter installed.
- `prometheus`: Collects and stores metrics.
- `grafana`: Displays dashboards based on Prometheus data.
- `registry`: Private Docker registry with HTTPS.
- `Makefile`: Simplifies management and operations.

---

## Prerequisites

- Docker
- Docker Compose
- Make
- OpenSSL

---

## Quick Start

```bash
# 1. Generate TLS certificates for Docker registry
make certs

# 2. Build and start all services
make up

# 3. Retrieve fresh JNLP secrets from Jenkins and update docker-compose
make refresh

# 4. Access interfaces:
# Jenkins:    http://localhost:8080 (login: admin / password: admin)
# Grafana:    http://localhost:3000 (login: admin / password: admin)
# Prometheus: http://localhost:9090
# Registry:   https://localhost:5000
```

---

## Makefile Commands

| Command        | Description                                                        |
|----------------|--------------------------------------------------------------------|
| `make up`      | Build and start all Docker services                                |
| `make certs`   | Generate self-signed TLS certificates for Docker registry          |
| `make refresh` | Fetch latest Jenkins agent secrets and update Docker Compose file |
| `make destroy` | Tear down all services, remove volumes and certificates            |
| `make help`    | Show list of available Makefile commands                           |

---

## Monitoring and Alerting

- **Prometheus** is configured to collect metrics from:
  - Jenkins at `/prometheus`
  - `node-exporter` running on `dev` and `prod` agents

- **Grafana** provides dashboards for:
  - Node resource usage (CPU, Memory, Disk, etc.)
  - Jenkins job statistics and health

- **Alerting rules** include:
  - High CPU or memory usage on agents
  - Jenkins service downtime

---

## Security

- Docker Registry uses TLS and is only accessible via HTTPS.
- Credentials and secrets are stored in environment variables and injected via `docker-compose`.
- Jenkins agents are authenticated using dynamically retrieved JNLP secrets.

---

## TODO

- Integrate with Slack/Telegram for alert notifications
- Automatic certificate renewal
- CI pipeline for infrastructure updates

---

## License

MIT