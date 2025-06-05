.PHONY: all copy run clean help

JENKINSFILE_SRC = JenkinsPipelines/Jenkinsfile
JENKINSFILE_DST = share/docker/jenkins/jobscripts/Jenkinsfile

all: copy run

copy:
	@echo "Copying Jenkinsfile to shared folder..."
	@mkdir -p $(dir $(JENKINSFILE_DST))
	@cp $(JENKINSFILE_SRC) $(JENKINSFILE_DST)

run:
	@echo "Starting Vagrant VM..."
	vagrant up

clean:
	@echo "Removing Jenkinsfile from shared folder..."
	@rm -f $(JENKINSFILE_DST)

help:
	@echo ""
	@echo "Available commands:"
	@echo "  make copy     - Copy Jenkinsfile to shared folder"
	@echo "  make run      - Start the Vagrant VM"
	@echo "  make clean    - Remove copied Jenkinsfile from shared folder"
	@echo "  make all      - Run copy and then run"
	@echo "  make help     - Show this help message"
