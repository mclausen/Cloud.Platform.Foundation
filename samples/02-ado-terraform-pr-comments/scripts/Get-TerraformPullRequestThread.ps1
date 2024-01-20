function Get-TerraformPullRequestThread {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $OrganizationUri,

        [Parameter(Mandatory=$true)]
        [string]
        $Project,

        [Parameter(Mandatory=$true)]
        [string]
        $PersonAccessToken,

        [Parameter(Mandatory=$true)]
        [string]
        $RepositoryId,

        [Parameter(Mandatory=$true)]
        [string]
        $PullRequestId,

        [Parameter(Mandatory=$true)]
        [string]
        $BuildId,

        [Parameter()]
        [string]
        $PullRequestCommentAnchor = "terraform-pullrequest"
    )
    
    $comments = Get-PullRequestComments `
            -OrganizationUri $organizationUri `
            -Project $projectName `
            -PersonAccessToken $personal_access_token `
            -RepositoryId $repositoryId `
            -PullRequestId $pullRequestId `
            -BuildId $buildId

    $terraformPullRequestThread = $comments `
        | Select-Object -ExpandProperty value `
        | Select-Object -Property id, @{ Name = 'Comment';  Expression = { $_.comments | Where-Object { $_.content -like "*$PullRequestCommentAnchor*" } } }
        | Where-Object { $null -ne $_.Comment }

    return $terraformPullRequestThread
}