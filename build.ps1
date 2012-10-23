param(
  [Parameter(Position=0,Mandatory=0)]
  [string]$buildFile = 'default.ps1',
  [Parameter(Position=1,Mandatory=0)]
  [string[]]$taskList = @(),
  [Parameter(Position=2,Mandatory=0)]
  [string]$framework = '3.5x86',
  [Parameter(Position=3,Mandatory=0)]
  [switch]$docs = $false,
  [Parameter(Position=4,Mandatory=0)]
  [System.Collections.Hashtable]$parameters = @{},
  [Parameter(Position=5, Mandatory=0)]
  [System.Collections.Hashtable]$properties = @{},
  [Parameter(Position=6, Mandatory=0)]
  [switch]$bootstrap
)

if($bootstrap) {
  $scriptPath = (Split-Path -parent $script:MyInvocation.MyCommand.Definition)
  Import-Module $scriptPath\src\chewie.psm1
  chewie install -nugetFile $scriptPath\.NugetFile
}

$psake = (Get-ChildItem . psake.ps1 -Recurse)

if(!$psake) {
  Write-Error "psake not found. Please run '.\build -bootstrap' to install dependencies."
  return
}

. $psake.Fullname $buildFile $taskList $framework $docs $parameters $properties
exit $lastexitcode