
function Test-Outdated {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$packageName
  )
  # TODO: See if we need to cache the calls to package version
  $targets = @((nuget list "$packageName" -AllVersions -Source $package.source) | ? { $_.Split()[0] -eq "$packageName"})
  if($targets.Length -gt 1) {
    # TODO: throw error on ambiguous package
    # this should never be possible, but...
  }
  if($target.Lenth -eq 0) {
    # TODO: Throw error that we could not find the package in any of the sources
  }
      
  if(![Version]::TryParse($targets[0].Split()[1], [ref] $targetVersion)){
    # TODO: Throw error - this should never happen as the nuget feed would be bad
  }
  
  $packageIsInstalled = Test-PackageInstalled $packageName
  $installedVersions = Get-InstalledPackageVersion $packageName
  if($packageIsInstalled -and ($installedVersion.Length -eq 0)) {
    # TODO: throw error :(
  }
  # TODO: Need to find the max version installed :/
     
  $chewie.executeddependencies.Push($packageKey)
  $false
}
