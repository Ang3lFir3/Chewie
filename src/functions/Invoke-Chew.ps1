
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
  
  if(!$chewie.Packages.Contains($packageKey)) {
    Write-ColoredOutput ($messages.warn_package_not_in_nugetfile -f $packageName) -ForegroundColor Magenta
    Resolve-Chew $packageName -prerelease $prerelease
  }
  $package = $chewie.Packages.$packageKey
  
  if ($chewie.ExecutedDependencies.Contains($packageKey))  { return }

  try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $chewie.currentpackageName = $packageName
    if ($PSBoundParameters['Verbose']) {
      if ($chewie.packageNameFormat -is [ScriptBlock]) {
        & $chewie.packageNameFormat $task $packageName
      } else {
        Write-ColoredOutput ($chewie.packageNameFormat -f $task, $packageName) -foregroundcolor Cyan
      }
    }
    if($task -eq "uninstall") {
      if(!(Test-PackageInstalled $packageName)) {
        Write-ColoredOutput "Could not uninstall $packageName. It is not installed." -foregroundcolor Magenta
        return
      }
      
      $paths = Get-PackageInstallationPaths $packageName
      $paths | % {
        Write-ColoredOutput "Uninstalling package $($package.name) from $($_|out-string)" -ForegroundColor Green
        Remove-Item -Recurse -Force $_ 
      }
      return
    }

    if($task -eq "outdated") {
      if(Test-Outdated $package.Name $package.Version $package.Source ($package.Prerelease -or $pre)) {
        Write-ColoredOutput "Package $($package.name) is outdated" -ForegroundColor Green
      } else {
        Write-ColoredOutput "Package $($package.name) is up-to-date" -ForegroundColor Green
      }
      return
    }
    
    if($task -eq "update") {
      Write-ColoredOutput "Package $($package.name) $($package.version) is being updated." -ForegroundColor Green
      [bool]$isOutdated = Test-Outdated $package.Name $package.Version  $package.Source ($package.Prerelease -or $pre)
      if($isOutdated) {
        Write-ColoredOutput "Package $($package.name) is outdated. Updating package." -ForegroundColor Green
        Invoke-Chew "uninstall" $packageName
        Invoke-Chew "install" $packageName
      } else {
        Write-ColoredOutput "Package $($package.name) is up-to-date." -ForegroundColor Green
      }
      return
    }

    if(Test-PackageInstalled $packageName) {
      Write-ColoredOutput "$packageName is already installed." -ForegroundColor Yellow
      return
    }

    $command = Resolve-NugetCommand $package

    Write-Debug "Running: invoke-expression $command"
    invoke-expression $command

    $package.Duration = $stopwatch.Elapsed
  } catch {
    if ($chewie.DebugPreference -eq "Continue") {
      "-"*70
      Write-ColoredOutput ($messages.continue_on_error -f $packageName,$_) -foregroundcolor Magenta
      "-"*70
      $package.Duration = $stopwatch.Elapsed
    }  else {
      throw $_
    }
  }

  $chewie.executeddependencies.Push($packageKey)
}