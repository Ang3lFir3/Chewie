
function Test-Outdated {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true)] [string]$packageName,
    [Parameter(Position=1,Mandatory=$true)] [string]$versionSpec
  )
  if(!(Test-PackageInstalled $packageName)) { return $true }
  [xml]$targets = Get-PackageList "$packageName"
  $versions = $targets.feed.entry | %{ (Get-VersionFromString $_.properties.version) }
  $matchingVersions = $versions | ? { Test-VersionCompatibility $versionSpec $_.Version.ToString() }
  $maxCompatibleVersion = Find-MaxVersion $matchingVersions
  $installedVersion = Get-InstalledPackageVersion $packageName
  $trueMaxVersion = Find-MaxVersion @($maxCompatibleVersion,$installedVersion)
  return ($trueMaxVersion -ne $installedVersion)
}

