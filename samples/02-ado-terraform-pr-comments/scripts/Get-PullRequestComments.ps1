function Get-PullRequestComments{
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
        $BuildId
    )
    
    $basicAuth =  "basic user:$PersonAccessToken"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( $basicAuth  ) )
    $headers = @{
                  Authorization = "Basic $Base64AuthInfo"
                }

    $newThreadEndpoint = "$( $OrganizationUri )/$( $Project )/_apis/git/repositories/$( $RepositoryId )/pullRequests/$( $PullRequestId )/threads?api-version=7.0"

    $thread = Invoke-RestMethod -Uri $newThreadEndpoint -Headers $headers  -Method Get -ContentType 'application/json'
    $thread
}