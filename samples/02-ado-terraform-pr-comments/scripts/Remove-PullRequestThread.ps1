function Remove-PullRequestThread{
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
        $ThreadId
    )
    
    $basicAuth =  "basic user:$PersonAccessToken"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( $basicAuth  ) )
    $headers = @{
                  Authorization = "Basic $Base64AuthInfo"
                }

    # Remove Thread
    $removeThreadEndpoint = "$( $OrganizationUri )/$( $Project )/_apis/git/repositories/$( $RepositoryId )/pullRequests/$( $PullRequestId )/threads/$( $ThreadId )?api-version=7.0"

    $thread = Invoke-RestMethod -Uri $removeThreadEndpoint -Headers $headers  -Method Delete -ContentType 'application/json'

    return $thread
}