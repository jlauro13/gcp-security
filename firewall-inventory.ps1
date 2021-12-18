function Get-firewallsSSH {
  $firewalls = gcloud asset search-all-resources `
            --asset-types "compute.googleapis.com/Firewall" `
            --scope="organizations/<org_id>" `
            --format=json `
            | ConvertFrom-Json
    return $firewalls | ForEach-Object -Parallel {
        $rules = gcloud compute firewall-rules list --filter="name=$($_.displayName) direction=INGRESS" `
            --project $_.parentFullResourceName.split("/")[-1] --format=json `
            | ConvertFrom-Json| Where-Object {
                try {
                    (($_.allowed.ports.Contains("3389") -or $_.allowed.ports.Contains("22"))) # $_.sourceRanges.Contains("35.235.240.0/20") <----- IAP network
                }
                catch {}
            }
        $rules | ConvertTo-Json -Depth 10
    } -ThrottleLimit 35
}
