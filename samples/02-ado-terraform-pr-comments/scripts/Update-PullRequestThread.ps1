function Update-PullRequestThread {
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

        [Parameter(Mandatory=$true)]
        [string]
        $ThreadId,

        [Parameter(Mandatory=$true)]
        [string]
        $PrComment
    )
    
    $basicAuth =  "basic user:$PersonAccessToken"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( $basicAuth  ) )
    $headers = @{
                  Authorization = "Basic $Base64AuthInfo"
                }

    # Updated Comment
    $updateCommentEndpoint = "$( $OrganizationUri )/$( $Project )/_apis/git/repositories/$( $RepositoryId )/pullRequests/$( $PullRequestId )/threads/$( $ThreadId )/comments/1?api-version=7.0"
    $updateComment = @{
        Content = $PrComment
    }
    $updateCommentBody = $updateComment | ConvertTo-Json -Depth 10
    $thread = Invoke-RestMethod -Uri $updateCommentEndpoint -Headers $headers -Method Patch -Body $updateCommentBody -ContentType 'application/json'
    
    # Updated Thread
    $newThreadEndpoint = "$( $OrganizationUri )/$( $Project )/_apis/git/repositories/$( $RepositoryId )/pullRequests/$( $PullRequestId )/threads/$( $ThreadId )?api-version=7.0"

    $newThread = @{
        Status = "Active"
    }

    $newThreadBody = $newThread | ConvertTo-Json -Depth 10

    $thread = Invoke-RestMethod -Uri $newThreadEndpoint -Headers $headers  -Method Patch -Body $newThreadBody -ContentType 'application/json'
}