
function Invoke-Chew {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)]
    [ValidateSet('install','update', 'uninstall', 'outdated')]
    [string] $task = $null,
    [Parameter(Position=1,Mandatory=$true)] [string]$packageName
  )

  Assert $packageName ($messages.error_invalid_package_name)

  $packageKey = $packageName.ToLower()

  Assert ($chewie.Packages.Contains($packageKey)) ($messages.error_package_name_does_not_exist -f $packageName)

  if ($chewie.ExecutedDependencies.Contains($packageKey))  { return }

  $package = $chewie.Packages.$packageKey

  try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $chewie.currentpackageName = $packageName

    if ($chewie.packageNameFormat -is [ScriptBlock]) {
      & $chewie.packageNameFormat $packageName
    } else {
      Write-ColoredOutput ($chewie.packageNameFormat -f $packageName) -foregroundcolor Cyan
    }
    
    if($task -eq "outdated") {
      Test-Outdated $packageName
      return
    }
    
    if($task -eq "update") {
      if(Test-Outdated $packageName) {
        #TODO
      }
      return
    }

    $command = Resolve-NugetCommand $package

    Write-Output "invoke-expression $command -WhatIf"
    #invoke-expression $command -WhatIf

    $package.Duration = $stopwatch.Elapsed
  } catch {
    if ($package.ContinueOnError) {
      "-"*70
      Write-ColoredOutput ($messages.continue_on_error -f $packageName,$_) -foregroundcolor Yellow
      "-"*70
      $package.Duration = $stopwatch.Elapsed
    }  else {
      throw $_
    }
  }

  $chewie.executeddependencies.Push($packageKey)
}