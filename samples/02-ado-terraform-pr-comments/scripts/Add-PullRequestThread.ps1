function Add-PullRequestThread{
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
        $PrComment
    )
    
    $basicAuth =  "basic user:$PersonAccessToken"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( $basicAuth  ) )
    $headers = @{
                  Authorization = "Basic $Base64AuthInfo"
                }

    $newThreadEndpoint = "$( $OrganizationUri )/$( $Project )/_apis/git/repositories/$( $RepositoryId )/pullRequests/$( $PullRequestId )/threads?api-version=7.0"

    $newThread = @{
                  Comments = @(
                      @{
                          ParentCommentId = 0
                          Content         = $PrComment
                          CommentType     = "text"
                      }
                  )
                  Status = "Active"
              }

    $newThreadBody = $newThread | ConvertTo-Json -Depth 10

    $thread = Invoke-RestMethod -Uri $newThreadEndpoint -Headers $headers  -Method Post -Body $newThreadBody -ContentType 'application/json'
    $thread
}