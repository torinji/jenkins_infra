import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.*
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition

def jenkins = Jenkins.instance
def jobsDir = new File("/var/jenkins_home/jobscripts")

if (!jobsDir.exists() || !jobsDir.isDirectory()) {
    println "Directory '${jobsDir}' does not exist or is not a directory."
    return
}

jobsDir.eachFileMatch(~/.*\.Jenkinsfile/) { file ->
    def jobName = file.name.replaceFirst(/\.Jenkinsfile$/, "")
    def scriptText = file.text

    if (jenkins.getItem(jobName) == null) {
        println "Creating job '${jobName}' from ${file.name}..."
        def job = jenkins.createProject(WorkflowJob, jobName)
        job.definition = new CpsFlowDefinition(scriptText, true)
    } else {
        println "Job '${jobName}' already exists, skipping..."
    }
}
