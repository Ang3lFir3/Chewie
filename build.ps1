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
  [System.Collections.Hashtable]$properties = @{}
)

$psake = (Get-ChildItem . psake.ps1 -Recurse)
if($psake.Length -eq 0) {
  $scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  . $scriptPath\src\chewie.ps1 install -nugetFile $scriptPath\.NugetFile
}

$psake = (Get-ChildItem . psake.ps1 -Recurse)

. $psake.Fullname $buildFile $taskList $framework $docs $parameters $properties
exit $lastexitcode