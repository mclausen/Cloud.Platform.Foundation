function Format-TerraformPullRequestThread {
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
       $BuildId,
       
       [Parameter(Mandatory=$true)]
       [string]
       $PullRequestId
   )

   $organizationUriWithoutTrailingSlash = $OrganizationUri.Substring(0,$OrganizationUri.Length-1)

   $buildUri = [Uri]::EscapeUriString("$( $organizationUriWithoutTrailingSlash )/$( $Project )/_build/results?buildId=$( $BuildId )&view=logs")

   $content = "# Infrastructure Changes :warning: `r`n" + `
       "Your build pipeline has detected changes!  `r`n" + `
       "The automated build pipeline **will change** the following infrastructure after completing this Pull request.`r`n`r`n`r`n`r`n " + `
       "[Click to go to detailed description]($( $buildUri ))`r`n"

   $codeBlock = Format-TerraformPlanOutputAsMarkdown -terraformPlanOutput $terraformPlanOutput
   $content += $codeBlock

   $content += "`r`n`r`n`r`n"
   $content += "---`r`n"
   $content += "The build pipeline automatically generates this comment..`r`n"
   
   # Hash the content
   $hasher = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
   $hash = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($codeBlock))
   $hashString = [System.BitConverter]::ToString($hash)
   $contentHash = $hashString.Replace('-', '').ToLower()

   $content += "<small>Hash: $contentHash</small> `r`n"

   $anchor = "terraform-pullrequest"
   $content += "<small>$anchor</small>"

   $obj = @{
       Content = $content
       ContentHash = $contentHash
       PullRequestThreadAnchor = $watermark
   }

   return $obj
}