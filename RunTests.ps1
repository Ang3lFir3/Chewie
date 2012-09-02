
$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)

function Load-Pester() {
  if(get-module pester) { return }
  
  $pesterModule = @(Get-ChildItem $scriptPath\* -recurse -include pester.psm1)
  if($pesterModule.Length -eq 0) {
    Write-Host "Could not find Pester, installing from nuget" -ForegroundColor Yellow
    nuget install pester -x -outputdirectory lib
    if(!(Test-Path $scriptPath\lib\Pester)) {
      Write-Host "Could not load Pester" -ForegroundColor Red
      return
    }
    Load-Pester
    return
  }
  Write-Host "Loading Pester: $pesterModule" -ForegroundColor Blue
  import-module $pesterModule
}

# Load Pester if needed
Load-Pester

# Run Pester
Invoke-Pester .\src\tests