function Set-PullRequestThread {
    param (
       [Parameter(Mandatory = $true)]
       [string]$TerraformPlanOutput,

       [Parameter(Mandatory=$true)]
       [string]
       $OrganizationUri,

       [Parameter(Mandatory=$true)]
       [string]
       $Project,

       [Parameter(Mandatory=$true)]
       [string]
       $RepositoryId,

       [Parameter(Mandatory=$true)]
       [string]
       $BuildId,
       
       [Parameter(Mandatory=$true)]
       [string]
       $PullRequestId,
       
       [Parameter(Mandatory=$true)]
       [string]
       $PersonalAccessToken
   )

   # Does Terraform Plan have changes?
   $doesHaveChanges = $TerraformPlanOutput -like "*Terraform will perform the following actions:*"
   
   # Does Pull Request have a comment?
   $existingPullRequestComment = Get-TerraformPullRequestThread `
       -OrganizationUri $OrganizationUri `
       -Project $Project `
       -PersonAccessToken $PersonalAccessToken `
       -RepositoryId $RepositoryId `
       -PullRequestId $PullRequestId `
       -BuildId $BuildId
   
   # Does not have changes and does not have existing comment
   if(($doesHaveChanges -eq $False) -and ($null -eq $existingPullRequestComment)) 
   {
       Write-Host "No terraform changes where found and no existing comment found. No action required."
       return
   }

   # Does have changes and no existing comment
   if(($doesHaveChanges) -and ($null -eq $existingPullRequestComment)) 
   {
       Write-Host "Terraform Changes Found, no previous comment found. Adding new PR Thread."
       $pullRequestComment = Format-TerraformPullRequestThread `
                       -TerraformPlanOutput $terraformPlanOutput `
                       -OrganizationUri $OrganizationUri `
                       -Project $Project `
                       -PullRequestId $PullRequestId `
                       -BuildId $BuildId

       Add-PullRequestThread `
           -OrganizationUri $OrganizationUri `
           -Project $Project `
           -PersonAccessToken $PersonalAccessToken `
           -RepositoryId $RepositoryId `
           -PullRequestId $PullRequestId `
           -BuildId $BuildId `
           -PrComment $pullRequestComment
   }

   # Does not have changes and has existing comment
   if(($doesHaveChanges -eq $False) -and ($null -ne $existingPullRequestComment)) 
   {
       Write-Host "No terraform changes where found and existing comment found. Removing PR Thread"
       Remove-PullRequestThread `
           -OrganizationUri $OrganizationUri `
           -Project $Project `
           -PersonAccessToken $PersonalAccessToken `
           -RepositoryId $RepositoryId `
           -PullRequestId $PullRequestId `
           -BuildId $BuildId `
           -ThreadId $existingPullRequestComment.id
   }

   # Does have changes and existing comment
   if(($doesHaveChanges) -and ($null -ne $existingPullRequestComment))
   {
       Write-Host "Terraform Changes Found and Terraform Thread was found. Updating PR Thread to Reflect Changes"
       $pullRequestComment = Format-TerraformPullRequestThread `
           -TerraformPlanOutput $terraformPlanOutput `
           -OrganizationUri $OrganizationUri `
           -Project $Project `
           -PullRequestId $PullRequestId `
           -BuildId $BuildId
       
        Update-PullRequestThread `
           -OrganizationUri $OrganizationUri `
           -Project $Project `
           -PersonAccessToken $PersonalAccessToken `
           -RepositoryId $RepositoryId `
           -PullRequestId $PullRequestId `
           -BuildId $BuildId `
           -ThreadId $existingPullRequestComment.id `
           -PrComment $pullRequestComment
   }    
}