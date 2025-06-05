$ip = "10.0.2.15"
$domains = @("jenkins.local", "grafana.local", "prometheus.local")
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

foreach ($domain in $domains) {
    $entry = "$ip `t $domain"
    if (-not (Select-String -Path $hostsPath -Pattern $domain -Quiet)) {
        Write-Host "Add $domain to hosts"
        Add-Content -Path $hostsPath -Value $entry
    } else {
        Write-Host "$domain already exist in hosts"
    }
}
