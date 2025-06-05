# Path to hosts file
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$backupPath = "$hostsPath.bak"

# Domains to remove
$domains = @("jenkins.local", "grafana.local", "prometheus.local")

# Create a backup of the original hosts file
Copy-Item -Path $hostsPath -Destination $backupPath -Force

# Filter out lines that contain any of the domains
(Get-Content $hostsPath) | Where-Object {
    $keep = $true
    foreach ($d in $domains) {
        if ($_ -match $d) { $keep = $false }
    }
    $keep
} | Set-Content $hostsPath

Write-Host "Removed specified entries. Backup saved as $backupPath"
