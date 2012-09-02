
function Test-Outdated {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$dependencyName
  )
  # TODO: See if we need to cache the calls to dependency version
  $targets = @((nuget list "$dependencyName" -AllVersions -Source $dependency.source) | ? { $_.Split()[0] -eq "$dependencyName"})
  if($targets.Length -gt 1) {
    # TODO: throw error on ambiguous dependency
    # this should never be possible, but...
  }
  if($target.Lenth -eq 0) {
    # TODO: Throw error that we could not find the dependency in any of the sources
  }
      
  if(![Version]::TryParse($targets[0].Split()[1], [ref] $targetVersion)){
    # TODO: Throw error - this should never happen as the nuget feed would be bad
  }
  
  $packageIsInstalled = Test-PackageInstalled $dependencyName
  $installedVersions = Get-InstalledVersion $dependencyName
  if($packageIsInstalled -and ($installedVersion.Length -eq 0)) {
    # TODO: throw error :(
  }
  # TODO: Need to find the max version installed :/
     
  $chewie.executeddependencies.Push($dependencyKey)
  $false
}
