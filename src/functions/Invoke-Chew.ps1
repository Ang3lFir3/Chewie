
function Invoke-Chew {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)]
    [ValidateSet('install','update', 'uninstall', 'outdated')]
    [string] $task = $null,
    [Parameter(Position=1,Mandatory=$true)] [string]$dependencyName
  )

  Assert $dependencyName ($messages.error_invalid_dependency_name)

  $dependencyKey = $dependencyName.ToLower()

  Assert ($chewie.dependencies.Contains($dependencyKey)) ($messages.error_dependency_name_does_not_exist -f $dependencyName)

  if ($chewie.ExecutedDependencies.Contains($dependencyKey))  { return }

  $dependency = $chewie.dependencies.$dependencyKey

  try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $chewie.currentdependencyName = $dependencyName

    if ($chewie.config.dependencyNameFormat -is [ScriptBlock]) {
      & $chewie.config.dependencyNameFormat $dependencyName
    } else {
      Write-ColoredOutput ($chewie.config.dependencyNameFormat -f $dependencyName) -foregroundcolor Cyan
    }
    
    if($task -eq "outdated") {
      Test-Outdated $dependencyName
      return
    }
    
	if($task -eq "update") {
      if(Test-Outdated $dependencyName) {
	  }
      return
    }

    $command = Resolve-NugetCommand $dependency
	
    Write-Output "invoke-expression $command -WhatIf"
    #invoke-expression $command -WhatIf

    $dependency.Duration = $stopwatch.Elapsed
  } catch {
    if ($dependency.ContinueOnError) {
      "-"*70
      Write-ColoredOutput ($messages.continue_on_error -f $dependencyName,$_) -foregroundcolor Yellow
      "-"*70
      $dependency.Duration = $stopwatch.Elapsed
    }  else {
      throw $_
    }
  }

  $chewie.executeddependencies.Push($dependencyKey)
}