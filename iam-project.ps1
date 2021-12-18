  function Get-iamPolicy {
    $projects = gcloud asset search-all-resources `
      --asset-types "cloudresourcemanager.googleapis.com/Project" `
      --scope="organizations/<org_id>" `
      --format=json `
    | ConvertFrom-Json
    foreach ($project in $projects) {
      gcloud projects get-iam-policy $($project.project.split("/")[-1]) --format=json >> "/Users/Downloads/$($project.project.split("/")[-1])_iam.json"
    }
  }
