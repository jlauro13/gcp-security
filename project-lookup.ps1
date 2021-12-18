function New-ProjectLookup {
  <#
  .SYNOPSIS
  Creates in memory key value lookup where key is projectid and value is project display name
  .DESCRIPTION
  Polling api every time for project names is expensive this function creates in memory key value lookup where key is projectid and value is project display name
  .PARAMETER OrganizationId
  GCP Organization ID
  .EXAMPLE
  $projects = New-ProjectLookup -OrganizationId "123456789"
  .NOTES
  Access project name: $projects["1097427954669"]
  #>
  param (
    #[string]$OrganizationId,
    [switch]$NameToNumber
  )
  $lookup = @{}
  $projects = gcloud asset search-all-resources `
    --asset-types "cloudresourcemanager.googleapis.com/Project" `
    --scope="organizations/<org_id>" `
    --filter="ACTIVE" `
    --format=json `
  | ConvertFrom-Json
  if ($NameToNumber.IsPresent) {
    foreach ($project in $projects) {
      [void]$lookup.Add($project.name.split("/")[-1], $project.project.split("/")[1])
    }
    $lookup
  }
  else {
    foreach ($project in $projects) {
      [void]$lookup.Add($project.project.split("/")[1], $project.name.split("/")[-1])
    }
    $lookup
  }
}
