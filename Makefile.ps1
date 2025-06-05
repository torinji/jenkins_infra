param (
    [string]$Command = "help"
)

$JenkinsfileSrc = "JenkinsPipelines\Jenkinsfile"
$JenkinsfileDst = "share\docker\jenkins\jobscripts\Jenkinsfile"

function Copy {
    Write-Output "Copying Jenkinsfile to shared folder..."
    $dstDir = Split-Path -Parent $JenkinsfileDst
    if (-Not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
    }
    Copy-Item $JenkinsfileSrc -Destination $JenkinsfileDst -Force
}

function Run {
    Write-Output "Starting Vagrant VM..."
    vagrant up
}

function Clean {
    Write-Output "Removing Jenkinsfile from shared folder..."
    if (Test-Path $JenkinsfileDst) {
        Remove-Item $JenkinsfileDst -Force
    }
}

function Help {
    Write-Output "`nAvailable commands:`n"
    Write-Output "  copy     - Copy Jenkinsfile to shared folder"
    Write-Output "  run      - Start the Vagrant VM"
    Write-Output "  clean    - Remove copied Jenkinsfile from shared folder"
    Write-Output "  all      - Run copy + run"
    Write-Output "  help     - Show this help message`n"
}

function All {
    Copy
    Run
}

switch ($Command.ToLower()) {
    "copy"  { Copy }
    "run"   { Run }
    "clean" { Clean }
    "all"   { All }
    "help"  { Help }
    default { Help }
}
