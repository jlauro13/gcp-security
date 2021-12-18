function Get-AllComputeInstances {
  param(
    [string]$OrganizationId = "332097842545"
  )
  $instances = gcloud asset search-all-resources `
    --asset-types “compute.googleapis.com/Instance” `
    --scope=organizations/$($OrganizationId) `
    --format=json `
  | ConvertFrom-Json
  return $instances | ForEach-Object -Parallel {
    gcloud compute instances describe $($_.name.split(“/”)[-1]) `
      --project $($_.parentFullResourceName.Split(“/”)[-1]) `
      --zone $($_.name.split(“/”)[-3]) `
      --format=json `
    | ConvertFrom-Json
  } -ThrottleLimit 50
}

#Get-AllComputeInstances | Select-Object -ExcludeProperty scheduling, fingerprint, labelFingerprint | ConvertTo-Json -Depth 10 >/var/log/gcp_resources/data/instances_inv.json
