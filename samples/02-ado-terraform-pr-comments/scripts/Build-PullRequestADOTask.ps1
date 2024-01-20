function Indent-MultilineString {
    param(
        [string]$String,
        [int]$IndentSize
    )

    $indentation = ' ' * $IndentSize
    $indentedLines = $String -split "`n" | ForEach-Object { $indentation + $_ }
    return $indentedLines -join "`n"
}

# Insert the content of the scripts into the template
$files = @(
    'Format-TerraformPlanOutputAsMarkdown.ps1',
    'Format-TerraformPullRequestThread.ps1',
    'Get-PullRequestComments.ps1',
    'Get-TerraformPullRequestThread.ps1',
    'Add-PullRequestThread.ps1',
    'Remove-PullRequestThread.ps1',
    'Update-PullRequestThread.ps1',
    'Set-PullRequestThread.ps1'
)

$placeHolderContent = ""

foreach($file in $files) {
    
    $fileContent = Get-Content -Path $file -Raw
    $content = "# $file`r`n"
    $content += $fileContent

    $placeHolderContent += Indent-MultilineString -String $content -IndentSize 8
    
    $placeHolderContent += "`r`n`r`n"
}



$invokeBlock = @"
Set-PullRequestThread `
    -TerraformPlanOutput `$(terraformPlanOutput`) `
    -OrganizationUri `$(`organizationUri`) `
    -Project `$(`projectName`) `
    -RepositoryId `$(repositoryId`) `
    -PullRequestId `$(`pullRequestId`) `
    -BuildId `$(buildId`) `
    -PersonalAccessToken `$(`personal_access_token`)
"@

$placeHolderContent += Indent-MultilineString -String $invokeBlock -IndentSize 8

# Write the template with the content of the scripts
$template = 'pull-request-comment-inline-template.yaml'
$outputPath = '../build/pull-request-comment-inline.yaml'
$templateContent = Get-Content -Path $template -Raw

$updatedTemplateContent = $templateContent.Replace('<#PLACEHOLDER#>', $placeHolderContent)

Out-File -FilePath $outputPath -InputObject $updatedTemplateContent -Encoding utf8 -Force


