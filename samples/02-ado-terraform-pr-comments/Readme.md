# Azure DevOps Pull Request Comment
Creates a Azure DevOps Pipelines yaml task that will take the terraform std output and Create a Pull Request Comment, if the build is being triggered by a Pull Request.

## How to build ADO task
Building the ADO task is straight forward, and it will be outputted as `pull-request-comment-inline.yaml` in `build` folder.

1. Go to scripts folder
2. Run `./Build-PullRequestADOTask.ps1`

## Using the Pull Request Comment file
### Using file directly
After a successfull build you can copy paste the `build/pull-request-comment-inline.yaml` to your repository directly.

### Reference the task from within your own pipeline
You can reference the task file from the github repo directly and stay updated.

``` yaml
resources:
  repositories:
  - repository: CloudPlatformFoundation # The name used to reference this repository in the checkout step
    type: github
    endpoint: MyGitHubServiceConnection
    name: mclausen/Cloud.Platform.Foundation

trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

steps: ...
- checkout: self
- checkout: CloudPlatformFoundation
- template: samples/02-ado-terraform-pr-comments/build/pull-request-comment-inline.yaml@CloudPlatformFoundation
  parameters:
    terraformOutput: $(terraformOutput) # the string output from terraform 

```