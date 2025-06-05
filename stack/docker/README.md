# Jenkins CI/CD Stack with Monitoring and Private Registry

## About

This folder contains the complete infrastructure setup for a local CI/CD platform. It runs **Jenkins**, **Prometheus**, **Grafana**, a private **Docker Registry**, and a reverse proxy (**nginx**) — all containerized and configured to work together inside a Vagrant-managed virtual machine.

The platform is intended for local development, testing, and monitoring of applications through automated pipelines and preconfigured dashboards.

---

## Components

* `jenkins`: Jenkins master server with predefined pipelines and Configuration-as-Code.
* `jenkins-agent-dev` / `jenkins-agent-prod`: Build agents with `node-exporter`.
* `prometheus`: Collects metrics from Jenkins and agents.
* `grafana`: Dashboards for Jenkins jobs, agent metrics, and alerts.
* `registry`: Local Docker registry secured with self-signed TLS.
* `nginx`: Reverse proxy that routes traffic to services like `jenkins.local`, `grafana.local`, etc.

---

## Prerequisites (inside the VM)

Ensure these tools are available **inside the virtual machine** after running `vagrant ssh`:

* Docker
* Docker Compose
* Make
* OpenSSL (used for TLS certificate generation)

They will be installed automatically via provisioning scripts during `vagrant up`.

---

## Setup Instructions

```bash
# Navigate to the project directory
# If you're inside the VM (via `vagrant ssh`):
cd /home/vagrant/stack/docker

# If you're accessing it from your host machine (shared folder):
cd /mnt/host_machine/stack/docker

# 1. Generate TLS certificates for the private registry
make certs

# 2. Start the full stack
make up

# 3. Fetch fresh Jenkins agent secrets and restart agents
make refresh
```

---

## Accessing Services

After setup, the following URLs become available via local DNS (make sure your host machine has the appropriate `/etc/hosts` entry):

```
127.0.0.1 jenkins.local grafana.local prometheus.local dev.local prod.local
```

| Service          | URL                                                | Default Credentials    |
| ---------------- | -------------------------------------------------- | ---------------------- |
| Jenkins          | [http://jenkins.local](http://jenkins.local)       | admin / admin          |
| Grafana          | [http://grafana.local](http://grafana.local)       | admin / admin          |
| Prometheus       | [http://prometheus.local](http://prometheus.local) | —                      |
| Dev Application  | [http://dev.local](http://dev.local)               | —                      |
| Prod Application | [http://prod.local](http://prod.local)             | —                      |
| Registry         | [https://localhost:5000](https://localhost:5000)   | (uses self-signed TLS) |

---

## Makefile Commands

| Command        | Description                                                    |
| -------------- | -------------------------------------------------------------- |
| `make up`      | Build and start all Docker services                            |
| `make certs`   | Generate self-signed TLS certificates for the private registry |
| `make refresh` | Fetch latest Jenkins agent secrets and restart services        |
| `make destroy` | Remove all containers, volumes, and generated certs            |
| `make help`    | Show available commands                                        |

---

## Dashboards & Monitoring

* **Prometheus** scrapes metrics from:

  * Jenkins (`/prometheus`)
  * Node Exporter on each agent

* **Grafana** displays:

  * Jenkins performance and job status
  * Resource usage (CPU, memory, disk) on build agents

* **Alerts** include:

  * Jenkins master down
  * High CPU/memory usage on agents

---

## Security Notes

* Registry is HTTPS-only (uses self-signed certs)
* JNLP secrets are dynamically pulled for Jenkins agents
* Passwords are stored via environment variables (`.env`)

---

## Future Enhancements

* Push CI/CD artifacts to private registry
* Add auto-cleanup jobs for old images
* Integrate Slack or Telegram for Prometheus alerts
* Replace self-signed certs with Let's Encrypt (via nginx)
* Add cAdvisor for container-level monitoring
* Support for GitHub webhook triggers in Jenkins

---

## 📝 License

Anton Zherebtsov, [torinji.san@gmail.com](mailto:torinji.san@gmail.com)
