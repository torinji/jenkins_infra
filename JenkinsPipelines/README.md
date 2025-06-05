
## ⚙️ Prerequisites

Make sure you have:

- A running **Jenkins instance**
- **Docker** installed on the Jenkins agent (if the pipeline builds Docker images)
- A Jenkins agent with the label `docker`
- The following **plugins** installed:
  - Docker Pipeline
  - Pipeline
  - Git

Optional (for registry support):
  - Docker Commons Plugin

---

## 🔧 Jenkins Setup Steps

1. **Create a New Pipeline Job**  
   In Jenkins:
   - Click “New Item”
   - Enter a name
   - Choose “Pipeline”
   - Click OK

2. **Set Pipeline Configuration**
   - Under **Pipeline → Definition**, select: `Pipeline script from SCM`
   - **SCM**: `Git`
   - **Repository URL**: your Git repository (e.g., `https://github.com/user/repo.git`)
   - **Branch**: `*/main` (or as needed)
   - **Script Path**: `Jenkinsfile`

3. **Save and Build**
   - Click “Save”
   - Click “Build Now” to trigger the pipeline

---

## 📝 Environment Variables

The `Jenkinsfile` supports the following parameters:

| Name             | Default                | Description                        |
|------------------|------------------------|------------------------------------|
| `GIT_REPO`       | `<your repo>`          | Repository containing source code  |
| `BRANCH`         | `main`                 | Git branch to build                |
| `DOCKER_REGISTRY`| `http://registry:5000` | Registry to push built image       |
| `IMAGE_NAME`     | `simple-web`           | Name of the Docker image           |
| `IMAGE_TAG`      | `latest`               | Tag for the Docker image           |
| `APP_PORT`       | `8000`                 | Port for health checks             |

---

## 🧪 Pipeline Overview

The pipeline includes the following stages:

1. **Checkout** – Clones the Git repository  
2. **Build Docker Image** – Builds a Docker image from source  
3. **Run Container** – Runs the image in a background container  
4. **Health Check** – Verifies app health via HTTP  
5. **Tag & Push** – Tags and pushes the image to a Docker registry (optional)

---

## ✅ Example

To test locally before pushing:

```bash
docker build -t simple-web:latest .
docker run -d -p 8000:8000 --name test-app simple-web:latest
curl http://localhost:8000/health

## 📝 License

Anton Zherebtsov, torinji.san@gmail.com