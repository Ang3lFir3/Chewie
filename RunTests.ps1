
$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)

. $scriptPath\src\chewie.ps1 install -nugetFile $scriptPath\.NugetFile

function Load-Pester() {
  if(get-module pester) { return }
  
  $pesterModule = @(Get-ChildItem $scriptPath\* -recurse -include pester.psm1)
  Write-Host "Loading Pester: $pesterModule" -ForegroundColor Blue
  import-module $pesterModule
}

# Load Pester if needed
Load-Pester

# Run Pester
Invoke-Pester .\src\tests