
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
    
    if($task -eq "uninstall") {
      if(!(Test-PackageInstalled $packageName)) {
        Write-ColoredOutput "Could not uninstall $packageName. It is not installed." -foregroundcolor Magenta
        return
      }
      $paths = Get-PackageInstallationPaths $packageName
      $paths | % { Remove-Item -Recurse -Force $_ }
      return
    }

    if($task -eq "outdated") {
      if(Test-Outdated $package.Name $package.Version) {
        Write-ColoredOutput "Package $($package.name) is outdated" -ForegroundColor Yellow
      } else {
        Write-ColoredOutput "Package $($package.name) is up-to-date" -ForegroundColor Yellow
      }
      return
    }
    
    if($task -eq "update") {
      if(Test-Outdated $package.Name $package.Version) {
        Write-ColoredOutput "Package $($package.name) is outdated. Updating package." -ForegroundColor Yellow
        Write-ColoredOutput "Package $($package.name) is outdated. Uninstalling old package." -ForegroundColor Yellow
        Invoke-Chew "uninstall" $packageName
        Write-ColoredOutput "Package $($package.name) is outdated. Installing new package." -ForegroundColor Yellow
        Invoke-Chew "install" $packageName
      }
      return
    }

    if(Test-PackageInstalled $packageName) {
      Write-ColoredOutput "$packageName is already installed." -ForegroundColor Yellow
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