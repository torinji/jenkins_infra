# Jenkins Automation with Vagrant and Docker

This project sets up a virtual machine using Vagrant, prepares it for running Docker Compose, and deploys infrastructure services including Jenkins, a sample web application, monitoring tools, and nginx as a reverse proxy.

If you prefer to build and run everything on your local machine without Vagrant, copy the `share/docker` directory and place your Jenkins pipelines in `share/docker/jenkins/jobscripts`.

## Requirements

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Make](https://www.gnu.org/software/make/) or compatible alternative  
  **or** use `Makefile.ps1` if you are on Windows with PowerShell.

## Usage

To automate the setup:

### On Linux/macOS:
```bash
make all
```

### On Windows (PowerShell):
```powershell
.\Makefile.ps1 all
```

Use `make help` or `.\Makefile.ps1 help` to see all available commands.

## 📝 License

Anton Zherebtsov, torinji.san@gmail.com