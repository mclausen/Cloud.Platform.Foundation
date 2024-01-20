function Format-TerraformPlanOutputAsMarkdown {
    param (
        [Parameter(Mandatory = $true)] 
        [string]$terraformPlanOutput
    )
    
    $content = ""

    $content += "``````"
    $includeLineSwitch = $false

    foreach ($item in $terraformPlanOutput) {
        if (-not $includeLineSwitch) {
            $includeLineSwitch = $item -like "*Terraform will perform the following actions:*"
        }
        
        if ($includeLineSwitch) {
            $content += "`r`n$( $item )" 
        }
    }
    $content += "`r`n``````"
    return $content
}